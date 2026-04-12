import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Controllers and State
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Color constants matching the image gradient
  final Color brandOrangeDark = const Color(0xFFE67E00);
  final Color brandOrangeLight = const Color(0xFFFFD54F);

  // 2. Dispose Method
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 3. Login Method
  void login() {
    // Calling the cubit logic as requested
    context.read<AuthCubit>().passwordLogin(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnauthenticatedState && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error!),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return SingleChildScrollView(
            child: Column(
              children: [
                /// --- TOP LOGO SECTION ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  color: Colors.white,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',

                      height: 280,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /// --- FORM SECTION (Rounded Gradient Container) ---
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [brandOrangeDark, brandOrangeLight],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Username Field
                      _buildInputGroup(
                        "email",
                        emailController,
                        "xyz@email.com",
                      ),

                      const SizedBox(height: 25),

                      // Password Field
                      _buildInputGroup(
                        "password",
                        passwordController,
                        "password",
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),


                      const SizedBox(height: 40),

                      /// LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: brandOrangeDark,
                                  ),
                                )
                              : Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: brandOrangeDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Footer
                      const Text(
                        "terms of services | privacy polciy",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper to build Label + TextField group
  Widget _buildInputGroup(
    String label,
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            cursorColor: brandOrangeDark,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
