import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _newHidden = true;
  bool _confirmHidden = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validate() {
    final password = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) return "Please fill in all fields.";
    if (password.length < 6) return "Password must be at least 6 characters.";
    if (password != confirm) return "Passwords do not match.";
    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
      return;
    }

    // TODO: send reset password request to backend
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.green,
        content: Text(
          "Password reset successfully!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    // Pop back to LoginPage — AuthGate handles routing from there.
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

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

          /// White Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Enter your new password below.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 28),

                  /// New Password
                  const Text("New Password", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _newHidden,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(_newHidden ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _newHidden = !_newHidden),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Confirm Password
                  const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _confirmHidden,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(_confirmHidden ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _confirmHidden = !_confirmHidden),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cta,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
