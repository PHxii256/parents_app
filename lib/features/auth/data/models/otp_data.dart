class Otp {
  final int value;
  final int duration; //in seconds
  Otp({required this.value, required this.duration});
}

class OtpVerificationData {
  final String resetToken;
  final String email;
  final bool requiresPasswordReset;

  OtpVerificationData({
    required this.resetToken,
    required this.email,
    required this.requiresPasswordReset,
  });
}
