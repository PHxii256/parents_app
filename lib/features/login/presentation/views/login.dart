import 'package:flutter/material.dart';
import 'package:parent_app/features/login/presentation/views/otpView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  bool isHidden = true;

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

                Text(
                  "Safe Route",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Be At Ease.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )

              ],
            ),
          ),

          /// Bottom Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  /// Phone Label
                  const Text(
                    "Phone no.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Phone Field
                  TextField(

                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                      ),

                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Password Label
                  const Text(
                    "Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Password Field
                  TextField(

                    obscureText: isHidden,

                    decoration: InputDecoration(

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
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

                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 16),

                      ),

                      onPressed: () {},

                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      ),

                    ),

                  ),

                  const SizedBox(height: 15),

                  /// Forgot Password

                  Center(
                    child: Row(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        const Text(
                          "Forgot Password? ",
                        ),

                        InkWell(
                          onTap: () {

                            Navigator.push(

                              context,

                                 MaterialPageRoute(

                                builder: (context) =>
                                const OtpView(),

                              ),

                            );

                          },

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
                  )

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}