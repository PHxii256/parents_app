import 'package:flutter/material.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

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

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: const [

                Text(
                  "Safe Route",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Be At Ease.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )

              ],
            ),
          ),

          /// White Section
          Expanded(
            child: Container(

              padding:
              const EdgeInsets.all(25),

              decoration: const BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.only(

                  topLeft:
                  Radius.circular(40),

                  topRight:
                  Radius.circular(40),

                ),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// Title

                  const Text(

                    "Verification Code",

                    style: TextStyle(

                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Phone Text

                  const Text(

                    "Sent to: +20 1020002650",

                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// OTP Boxes

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      otpBox(),
                      otpBox(),
                      otpBox(),
                      otpBox(),
                      otpBox(),
                      otpBox(),

                    ],
                  ),

                  const SizedBox(height: 80),

                  /// Resend Text

                  Center(

                    child: Row(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        const Text(
                          "Didn’t Receive SMS? ",
                          style:
                          TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        InkWell(

                          onTap: () {

                            print("Resend");

                          },

                          child: const Text(

                            "Resend",

                            style: TextStyle(

                              fontSize: 16,

                              decoration:
                              TextDecoration
                                  .underline,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                        ),


                      ],
                    ),
                  ),

                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  /// OTP Box Widget

  Widget otpBox() {

    return Container(

      width: 50,
      height: 60,

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),

      ),

      child: const TextField(

        textAlign:
        TextAlign.center,

        keyboardType:
        TextInputType.number,

        maxLength: 1,

        decoration:
        InputDecoration(

          counterText: "",
          border:
          InputBorder.none,

        ),

      ),

    );
  }
}