import 'package:parent_app/features/auth/data/models/otp_data.dart';

sealed class OtpResult {}

class OtpSuccess extends OtpResult {
  final Otp otp;
  OtpSuccess(this.otp);
}

class OtpFailure extends OtpResult {
  final String message;
  OtpFailure(this.message);
}

class OtpVerifySuccess extends OtpResult {
  final OtpVerificationData data;
  OtpVerifySuccess(this.data);
}
