import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parent_app/features/login/presentation/reset_password_page.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});
  final String email = "example@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          /// Yellow Header
          Container(
            height: 260,
            width: double.infinity,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Safe Route", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text("Be At Ease.", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Verification Code",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text("Sent to: $email", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  OtpGroup(),
                  const SizedBox(height: 24),
                  Resend(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Resend extends StatefulWidget {
  const Resend({super.key});

  @override
  State<Resend> createState() => _ResendState();
}

class _ResendState extends State<Resend> {
  static const int _initialSeconds = 90;
  int _secondsLeft = _initialSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _initialSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    _startTimer();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Code sent! Check your email.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  String get _formattedTime {
    final m = _secondsLeft ~/ 60;
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Didn't receive a code? ", style: TextStyle(fontSize: 16)),
          if (canResend)
            GestureDetector(
              onTap: _resend,
              child: const Text(
                "Resend",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              "Resend in $_formattedTime",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }
}

class OtpGroup extends StatefulWidget {
  const OtpGroup({super.key});

  @override
  State<OtpGroup> createState() => _OtpGroupState();
}

class _OtpGroupState extends State<OtpGroup> {
  bool checkOtp(String otpText) {
    return true;
  }

  final List<TextEditingController> textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  bool valid = false;

  @override
  void initState() {
    super.initState();
    for (final c in textControllers) {
      c.addListener(validate);
    }
  }

  @override
  void dispose() {
    for (final c in textControllers) {
      c.removeListener(validate);
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void validate() {
    final allFilled = textControllers.every((c) => c.text.isNotEmpty);
    if (allFilled != valid) setState(() => valid = allFilled);
  }

  void submit() {
    String text = "";
    for (var controller in textControllers) {
      text += controller.text;
    }
    if (checkOtp(text)) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Wrong Code, Try Again",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void nextFocus(FocusNode current) {
    current.unfocus();
    final i = focusNodes.indexOf(current);
    if (focusNodes.length > i + 1) {
      focusNodes[i + 1].requestFocus();
    }
  }

  void prevFocus(FocusNode current) {
    current.unfocus();
    final i = focusNodes.indexOf(current);
    if (i - 1 >= 0) {
      focusNodes[i - 1].requestFocus();
    }
  }

  // moves the cursor to the end of the text in the otp box.
  void onTap(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }

  List<OtpBox> getOtpBoxes() {
    List<OtpBox> temp = [];
    for (var i = 0; i < textControllers.length; i++) {
      focusNodes[i].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            textControllers[i].text.isEmpty) {
          prevFocus(focusNodes[i]);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
      temp.add(
        OtpBox(
          nextFocus: nextFocus,
          onTap: onTap,
          focusNode: focusNodes[i],
          controller: textControllers[i],
          allControllers: textControllers,
          allFocusNodes: focusNodes,
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...getOtpBoxes(),
        GestureDetector(
          onTap: valid ? submit : null,
          child: Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: valid ? AppColors.cta : AppColors.highlight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cta, width: 2),
            ),
            child: Icon(Icons.check, color: valid ? Colors.white : Colors.amber.shade300),
          ),
        ),
      ],
    );
  }
}

class OtpInputFormatter extends TextInputFormatter {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<TextEditingController> allControllers;
  final List<FocusNode> allFocusNodes;
  final void Function(FocusNode) nextFocus;

  OtpInputFormatter({
    required this.controller,
    required this.focusNode,
    required this.allControllers,
    required this.allFocusNodes,
    required this.nextFocus,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return const TextEditingValue();

    // Paste: more than one character was added at once
    if (newValue.text.length > oldValue.text.length + 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final startIndex = allControllers.indexOf(controller);
        for (var j = 0; j < digits.length && (startIndex + j) < allControllers.length; j++) {
          allControllers[startIndex + j].text = digits[j];
        }
        final lastFilled = (startIndex + digits.length - 1).clamp(0, allControllers.length - 1);
        final nextIndex = lastFilled + 1;
        if (nextIndex < allFocusNodes.length) {
          allFocusNodes[nextIndex].requestFocus();
        } else {
          allFocusNodes[lastFilled].unfocus();
        }
      });
      return TextEditingValue(text: digits[0], selection: const TextSelection.collapsed(offset: 1));
    }

    // Single digit typed — take the last digit (handles replacing an existing one)
    final result = digits[digits.length - 1];
    if (oldValue.text != result) {
      WidgetsBinding.instance.addPostFrameCallback((_) => nextFocus(focusNode));
    }
    return TextEditingValue(text: result, selection: const TextSelection.collapsed(offset: 1));
  }
}

class OtpBox extends StatelessWidget {
  final Function(FocusNode currentNode) nextFocus;
  final Function(TextEditingController controller) onTap;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<TextEditingController> allControllers;
  final List<FocusNode> allFocusNodes;
  const OtpBox({
    super.key,
    required this.nextFocus,
    required this.focusNode,
    required this.controller,
    required this.onTap,
    required this.allControllers,
    required this.allFocusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            OtpInputFormatter(
              controller: controller,
              focusNode: focusNode,
              allControllers: allControllers,
              allFocusNodes: allFocusNodes,
              nextFocus: nextFocus,
            ),
          ],
          onTap: () => onTap(controller),
          decoration: InputDecoration(counterText: "", border: InputBorder.none),
        ),
      ),
    );
  }
}
