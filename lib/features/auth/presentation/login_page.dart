import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/features/auth/presentation/otp_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Maps to `/api/v1/{guardian|driver|assistant}/auth/...`.
  String _accountTypeForApi = 'parent';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showLocalError(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.clearSnackBars();
    messenger?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _toggleApiMode() {
    final isRealApi = ApiConfig.toggleUseRealApi();
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(isRealApi ? 'Real API enabled' : 'Mock API enabled'),
      ),
    );
    setState(() {});
  }

  void login() {
    final localizations = AppLocalizations.of(context)!;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showLocalError(localizations.validationFillAllFields);
      return;
    }
    context.read<AuthCubit>().passwordLogin(
      email: email,
      password: password,
      accountTypeForApi: _accountTypeForApi,
    );
  }

  void resetPass() {
    if (mounted) {
      final segment = ApiConfig.roleAuthPathSegment(_accountTypeForApi);
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => OtpPage(
            email: emailController.text,
            role: segment,
            password: passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is OtpSentState,
      listener: (context, state) {
        if (state is OtpSentState) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => OtpPage(
                email: state.email,
                role: state.role,
                initialSeconds: state.duration,
                password: state.password,
              ),
            ),
          );
          return;
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              /// Top Yellow Section
              Container(
                height: 330,
                width: double.infinity,
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _toggleApiMode,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        "Safe Route",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      localizations.appTagline,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              /// Bottom Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (ApiConfig.useRealApi) ...[
                        const SizedBox(height: 8),
                        Text(
                          localizations.accountTypeLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _accountTypeForApi,
                                items: [
                                  DropdownMenuItem(
                                    value: 'parent',
                                    child: Text(
                                      localizations.accountTypeParentGuardian,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'driver',
                                    child: Text(
                                      localizations.accountTypeDriver,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'assistant',
                                    child: Text(
                                      localizations.accountTypeAssistant,
                                    ),
                                  ),
                                ],
                                onChanged: isLoading
                                    ? null
                                    : (v) {
                                        if (v != null) {
                                          setState(
                                            () => _accountTypeForApi = v,
                                          );
                                        }
                                      },
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      Text(
                        localizations.emailLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.passwordLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: isHidden,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  localizations.loginButton,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// Forgot Password
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(localizations.forgotPasswordPrompt),
                            InkWell(
                              onTap: resetPass,
                              child: Text(
                                localizations.resetAction,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
