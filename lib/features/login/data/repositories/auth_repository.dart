import 'package:dio/dio.dart';
import 'package:parent_app/core/dio/res_util.dart';
import 'package:parent_app/core/models/server_exception.dart';
import 'package:parent_app/core/models/user_data.dart';
import 'package:parent_app/features/login/data/models/login_result.dart';
import 'package:parent_app/features/login/data/models/otp_data.dart';
import 'package:parent_app/features/login/data/models/otp_result.dart';
import 'package:parent_app/features/login/data/provider/auth_data_provider.dart';

class AuthRepository {
  final AuthDataProvider authData = AuthDataProvider();

  Future<LoginResult> passwordLogin({required String email, required String password}) async {
    try {
      final response = await authData.passwordLogin(email, password);
      final user = User.fromJson(response.data["user"]);
      final refreshToken = response.data["refreshToken"];
      final accessToken = response.data["accessToken"];
      return LoginSuccess(user: user, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      return LoginFailure("Invalid email or password");
    }
  }

  Future<LoginResult> jwtLogin({required String accessToken, required String refreshToken}) async {
    try {
      final response = await authData.jwtLogin(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      final user = User.fromJson(response.data["user"]);
      final newRefresh = response.data["refreshToken"];
      final newAccess = response.data["accessToken"];
      return LoginSuccess(user: user, accessToken: newAccess, refreshToken: newRefresh);
    } catch (e) {
      return LoginFailure("Invalid JWT");
    }
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String otp,
    required String email,
  }) async {
    try {
      final response = await authData.resetPassword(
        newPassword: newPassword,
        otp: otp,
        email: email,
      );
      return isResOk(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout({String? accessToken, String? refreshToken}) async {
    try {
      if (accessToken != null && refreshToken != null) {
        return await clearJWT(accessToken: accessToken, refreshToken: refreshToken);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearJWT({required String accessToken, required String refreshToken}) async {
    final resServer = await _clearServerJWT(accessToken: accessToken, refreshToken: refreshToken);
    final resClient = await _clearClientJWT(accessToken: accessToken, refreshToken: refreshToken);

    if (resClient && resServer) return true;
    return false;
  }

  Future<bool> _clearServerJWT({required String accessToken, required String refreshToken}) async {
    try {
      final response = await authData.logout(accessToken: accessToken, refreshToken: refreshToken);
      return isResOk(response);
    } on DioException catch (e) {
      throw ServerException(message: '${e.response?.data['message'] ?? 'Network error'}');
    }
  }

  Future<bool> _clearClientJWT({required String accessToken, required String refreshToken}) async {
    // clear local JWT storage
    return true;
  }

  Future<OtpResult> requestOTP({required String email}) async {
    final response = await authData.requestOTP(email: email);
    try {
      return OtpSuccess(Otp(value: response.data["value"], duration: response.data["duration"]));
    } catch (e) {
      return OtpFailure("Otp invalid or expired.");
    }
  }
}
