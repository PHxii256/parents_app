import 'package:parent_app/features/login/data/models/otp_data.dart';

sealed class OtpResult {}

class OtpSuccess extends OtpResult {
  final Otp otp;
  OtpSuccess(this.otp);
}

class OtpFailure extends OtpResult {
  final String message;
  OtpFailure(this.message);
}
