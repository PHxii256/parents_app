import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String role;
  final String resetToken;
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.role,
    required this.resetToken,
  });

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

  String? _validate(AppLocalizations localizations) {
    final password = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) return localizations.validationFillAllFields;
    if (password.length < 6) return localizations.validationPasswordMinLength;
    if (password != confirm) return localizations.validationPasswordsDoNotMatch;
    return null;
  }

  void _submit() {
    final localizations = AppLocalizations.of(context)!;
    final error = _validate(localizations);
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

    context.read<AuthCubit>().resetPassword(
      newPassword: _newPasswordController.text.trim(),
      otp: widget.resetToken,
      email: widget.email,
      role: widget.role,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccessState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1500),
              backgroundColor: Colors.green,
              content: Text(
                localizations.passwordResetSuccess,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
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
          Container(
            height: 260,
            width: double.infinity,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Safe Route",

                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(localizations.appTagline, style: const TextStyle(fontSize: 18)),
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
                  Text(
                    localizations.resetPasswordTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.resetPasswordSubtitle,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 28),

                  /// New Password
                  Text(
                    localizations.newPasswordLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  Text(
                    localizations.confirmPasswordLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                      child: Text(
                        localizations.resetPasswordButton,
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
      ),
    );
  }
}
