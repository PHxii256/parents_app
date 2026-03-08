import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/views/home_page.dart';
import 'package:parent_app/features/login/presentation/views/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;

  void login() {
    // first we should send a request with the jwt token(s) for auth
    // if response is successful refresh the token and move the user to home/
    // this logic should be done in a bloc.
    if (mounted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  void resetPass() {
    // should send a request to the backend to email the otp to this account
    if (mounted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacement(MaterialPageRoute(builder: (_) => OtpPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Text("Safe Route", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text("Be At Ease.", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          /// Bottom Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 24),
                physics: BouncingScrollPhysics(),
                children: [
                  /// Phone Label
                  const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  /// Phone Field
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Password Label
                  const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  /// Password Field
                  TextField(
                    obscureText: isHidden,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
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
                      onPressed: login,
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Forgot Password
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Forgot Password? "),
                        InkWell(
                          onTap: resetPass,
                          child: const Text(
                            "Reset",
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
  }
}
