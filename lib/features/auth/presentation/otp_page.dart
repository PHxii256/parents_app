import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/features/auth/presentation/reset_password_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class OtpPage extends StatelessWidget {
  final String email;
  final String role;
  final String password;
  final int initialSeconds;
  const OtpPage({
    super.key,
    required this.email,
    required this.role,
    this.password = '',
    this.initialSeconds = 90,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpVerifiedState) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ResetPasswordPage(
                email: state.email,
                role: state.role,
                resetToken: state.resetToken,
              ),
            ),
          );
        } else if (state is UnauthenticatedState && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            /// Yellow Header
            Stack(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Safe Route",

                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        localizations.appTagline,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.verificationCodeTitle,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localizations.sentToEmail(email),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    OtpGroup(email: email, role: role),
                    const SizedBox(height: 24),
                    Resend(
                      email: email,
                      role: role,
                      password: password,
                      initialSeconds: initialSeconds,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Resend extends StatefulWidget {
  final String email;
  final String role;
  final String password;
  final int initialSeconds;
  const Resend({
    super.key,
    required this.email,
    required this.role,
    required this.password,
    this.initialSeconds = 90,
  });

  @override
  State<Resend> createState() => _ResendState();
}

class _ResendState extends State<Resend> {
  int _secondsLeft = 90;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.initialSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.initialSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    context.read<AuthCubit>().resendOtp(
      email: widget.email,
      password: widget.password,
      role: widget.role,
    );
    _startTimer();
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          localizations.otpCodeSentSuccess,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
    final localizations = AppLocalizations.of(context)!;
    final canResend = _secondsLeft == 0;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localizations.otpDidNotReceiveCode,
            style: const TextStyle(fontSize: 16),
          ),
          if (canResend)
            GestureDetector(
              onTap: _resend,
              child: Text(
                localizations.otpResend,
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              localizations.otpResendIn(_formattedTime),
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }
}

class OtpGroup extends StatefulWidget {
  final String email;
  final String role;
  const OtpGroup({super.key, required this.email, required this.role});

  @override
  State<OtpGroup> createState() => _OtpGroupState();
}

class _OtpGroupState extends State<OtpGroup> {
  static const int _otpLength = 6;

  final List<TextEditingController> textControllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(_otpLength, (_) => FocusNode());

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
    context.read<AuthCubit>().verifyOtp(
      role: widget.role,
      email: widget.email,
      otp: text,
    );
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
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
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
              color: valid ? AppColors.cta : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cta, width: 2),
            ),
            child: Icon(
              Icons.check,
              color: valid ? Colors.white : Colors.amber.shade300,
            ),
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
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return const TextEditingValue();

    // Paste: more than one character was added at once
    if (newValue.text.length > oldValue.text.length + 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final startIndex = allControllers.indexOf(controller);
        for (
          var j = 0;
          j < digits.length && (startIndex + j) < allControllers.length;
          j++
        ) {
          allControllers[startIndex + j].text = digits[j];
        }
        final lastFilled = (startIndex + digits.length - 1).clamp(
          0,
          allControllers.length - 1,
        );
        final nextIndex = lastFilled + 1;
        if (nextIndex < allFocusNodes.length) {
          allFocusNodes[nextIndex].requestFocus();
        } else {
          allFocusNodes[lastFilled].unfocus();
        }
      });
      return TextEditingValue(
        text: digits[0],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }

    // Single digit typed — take the last digit (handles replacing an existing one)
    final result = digits[digits.length - 1];
    if (oldValue.text != result) {
      WidgetsBinding.instance.addPostFrameCallback((_) => nextFocus(focusNode));
    }
    return TextEditingValue(
      text: result,
      selection: const TextSelection.collapsed(offset: 1),
    );
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
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
