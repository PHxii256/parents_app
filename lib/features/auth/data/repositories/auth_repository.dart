import 'package:dio/dio.dart';
import 'package:parent_app/core/dio/res_util.dart';
import 'package:parent_app/core/models/server_exception.dart';
import 'package:parent_app/core/models/user_data.dart';
import 'package:parent_app/features/auth/data/models/login_result.dart';
import 'package:parent_app/features/auth/data/models/otp_data.dart';
import 'package:parent_app/features/auth/data/models/otp_result.dart';
import 'package:parent_app/features/auth/data/provider/auth_data_provider.dart';
import 'package:parent_app/features/auth/data/services/jwt_storage.dart';

class AuthRepository {
  final AuthDataProvider authData = AuthDataProvider();
  final JwtStorage _jwtStorage = JwtStorage();

  // TODO: replace with real API call once backend is ready
  static const _parentTestEmail = 'e@test.com';
  static const _parentTestPassword = 'password';
  static const _staffTestEmail = 's@test.com';
  static const _staffTestPassword = 'password';

  static const _mockParentAccessToken = 'mock_parent_access_token';
  static const _mockParentRefreshToken = 'mock_parent_refresh_token';
  static const _mockStaffAccessToken = 'mock_staff_access_token';
  static const _mockStaffRefreshToken = 'mock_staff_refresh_token';

  Future<LoginResult> passwordLogin({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (email == _parentTestEmail && password == _parentTestPassword) {
      await _jwtStorage.save(
        accessToken: _mockParentAccessToken,
        refreshToken: _mockParentRefreshToken,
      );
      return LoginSuccess(
        user: User(id: '1', email: email, username: 'TestUser', role: 'parent'),
        accessToken: _mockParentAccessToken,
        refreshToken: _mockParentRefreshToken,
      );
    }

    if (email == _staffTestEmail && password == _staffTestPassword) {
      await _jwtStorage.save(
        accessToken: _mockStaffAccessToken,
        refreshToken: _mockStaffRefreshToken,
      );
      return LoginSuccess(
        user: User(id: '2', email: email, username: 'TestStaff', role: 'driver'),
        accessToken: _mockStaffAccessToken,
        refreshToken: _mockStaffRefreshToken,
      );
    }

    return LoginFailure('Invalid email or password');
  }

  Future<LoginResult> jwtLogin({required String accessToken, required String refreshToken}) async {
    // TODO: replace with real API call once backend is ready
    if (accessToken == _mockParentAccessToken && refreshToken == _mockParentRefreshToken) {
      return LoginSuccess(
        user: User(id: '1', email: _parentTestEmail, username: 'TestUser', role: 'parent'),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    if (accessToken == _mockStaffAccessToken && refreshToken == _mockStaffRefreshToken) {
      return LoginSuccess(
        user: User(id: '2', email: _staffTestEmail, username: 'TestStaff', role: 'driver'),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    try {
      final response = await authData.jwtLogin(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      final user = User.fromJson(response.data["user"]);
      final newRefresh = response.data["refreshToken"];
      final newAccess = response.data["accessToken"];
      await _jwtStorage.save(accessToken: newAccess, refreshToken: newRefresh);
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
    await _jwtStorage.clear();
    return true;
  }

  /// Loads tokens saved from the last successful login. Returns null if none are stored.
  Future<({String accessToken, String refreshToken})?> loadStoredTokens() => _jwtStorage.load();

  /// Removes stored tokens without contacting the server.
  Future<void> clearStoredTokens() => _jwtStorage.clear();

  Future<OtpResult> requestOTP({required String email}) async {
    final response = await authData.requestOTP(email: email);
    try {
      return OtpSuccess(Otp(value: response.data["value"], duration: response.data["duration"]));
    } catch (e) {
      return OtpFailure("Otp invalid or expired.");
    }
  }
}
