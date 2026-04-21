import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/dio/res_util.dart';
import 'package:parent_app/core/models/server_exception.dart';
import 'package:parent_app/core/models/user_data.dart';
import 'package:parent_app/features/auth/data/models/login_result.dart';
import 'package:parent_app/features/auth/data/models/otp_data.dart';
import 'package:parent_app/features/auth/data/models/otp_result.dart';
import 'package:parent_app/features/auth/data/models/reset_password_flow_result.dart';
import 'package:parent_app/features/auth/data/provider/auth_data_provider.dart';
import 'package:parent_app/features/auth/data/services/auth_role_store.dart';
import 'package:parent_app/features/auth/data/services/jwt_storage.dart';

class AuthRepository {
  final AuthDataProvider authData;
  final JwtStorage _jwtStorage;
  final AuthRoleStore _authRoleStore;

  AuthRepository({
    AuthDataProvider? authDataProvider,
    JwtStorage? jwtStorage,
    AuthRoleStore? authRoleStore,
  }) : authData = authDataProvider ?? AuthDataProvider(),
       _jwtStorage = jwtStorage ?? JwtStorage(),
       _authRoleStore = authRoleStore ?? AuthRoleStore();

  // TODO: replace with real API call once backend is ready
  static const _parentTestEmail = 'e@test.com';
  static const _parentTestPassword = 'password';
  static const _staffTestEmail = 's@test.com';
  static const _staffTestPassword = 'password';
  static const _assistantTestEmail = 'a@test.com';
  static const _assistantTestPassword = 'password';

  static const _mockParentAccessToken = 'mock_parent_access_token';
  static const _mockParentRefreshToken = 'mock_parent_refresh_token';
  static const _mockStaffAccessToken = 'mock_staff_access_token';
  static const _mockStaffRefreshToken = 'mock_staff_refresh_token';
  static const _mockAssistantAccessToken = 'mock_assistant_access_token';
  static const _mockAssistantRefreshToken = 'mock_assistant_refresh_token';

  /// Segment for `POST /api/v1/{role}/auth/...`. Mock test emails map to staff roles;
  /// other addresses default to `guardian` until the server returns tokens (JWT carries role).
  static String authPathRoleForEmail(String email) {
    final e = email.trim().toLowerCase();
    if (e == _parentTestEmail) return 'guardian';
    if (e == _staffTestEmail) return 'driver';
    if (e == _assistantTestEmail) return 'assistant';
    return 'guardian';
  }

  /// [accountTypeForApi] is the app account kind: `parent`, `driver`, or `assistant`
  /// (maps to guardian / driver / assistant URL segments). Ignored for mock test emails.
  Future<LoginResult> passwordLogin({
    required String email,
    required String password,
    String accountTypeForApi = 'parent',
  }) async {
    final trimmed = email.trim();
    final pathRole = _isMockTestEmail(trimmed)
        ? authPathRoleForEmail(trimmed)
        : ApiConfig.roleAuthPathSegment(accountTypeForApi);
    await Future.delayed(const Duration(milliseconds: 300));
    if (trimmed == _parentTestEmail && password == _parentTestPassword) {
      await _authRoleStore.saveRole('guardian');
      await _jwtStorage.save(
        accessToken: _mockParentAccessToken,
        refreshToken: _mockParentRefreshToken,
      );
      return LoginSuccess(
        user: User(id: '1', email: trimmed, username: 'TestUser', role: 'parent'),
        accessToken: _mockParentAccessToken,
        refreshToken: _mockParentRefreshToken,
      );
    }

    if (trimmed == _staffTestEmail && password == _staffTestPassword) {
      await _authRoleStore.saveRole('driver');
      await _jwtStorage.save(
        accessToken: _mockStaffAccessToken,
        refreshToken: _mockStaffRefreshToken,
      );
      return LoginSuccess(
        user: User(id: '2', email: trimmed, username: 'TestStaff', role: 'driver'),
        accessToken: _mockStaffAccessToken,
        refreshToken: _mockStaffRefreshToken,
      );
    }

    if (trimmed == _assistantTestEmail && password == _assistantTestPassword) {
      await _authRoleStore.saveRole('assistant');
      await _jwtStorage.save(
        accessToken: _mockAssistantAccessToken,
        refreshToken: _mockAssistantRefreshToken,
      );
      return LoginSuccess(
        user: User(id: '3', email: trimmed, username: 'TestAssistant', role: 'assistant'),
        accessToken: _mockAssistantAccessToken,
        refreshToken: _mockAssistantRefreshToken,
      );
    }

    if (!ApiConfig.useRealApi) {
      return LoginFailure('Invalid email or password');
    }

    try {
      final response = await authData.passwordLogin(
        role: pathRole,
        email: trimmed,
        password: password,
      );
      _debugLogAuthResponse('login OK', response.statusCode, response.data);
      final data = _extractResponseData(response);
      final accessToken = data['access'] as String?;
      final refreshToken = data['refresh'] as String?;
      if (accessToken != null && refreshToken != null) {
        await _jwtStorage.save(accessToken: accessToken, refreshToken: refreshToken);
        final user = _userFromAccessToken(accessToken, fallbackRole: pathRole, fallbackEmail: trimmed);
        await _authRoleStore.saveRole(user.role);
        return LoginSuccess(user: user, accessToken: accessToken, refreshToken: refreshToken);
      }

      final remainingSeconds = (data['remaining_time'] as num?)?.toInt();
      if (remainingSeconds != null) {
        await _authRoleStore.saveRole(pathRole);
        return LoginOtpRequired(
          email: trimmed,
          role: pathRole,
          remainingSeconds: remainingSeconds,
          password: password,
        );
      }
      return LoginFailure('Unexpected login response.');
    } on ServerException catch (e) {
      if (kDebugMode) {
        debugPrint('[Auth] login rejected: ${e.message}');
      }
      return LoginFailure(e.message);
    } on DioException catch (e) {
      _debugLogAuthResponse('login error', e.response?.statusCode, e.response?.data);
      return LoginFailure(_loginFailureMessageFromDio(e));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Auth] login error: $e');
      }
      return LoginFailure(e.toString());
    }
  }

  static bool _isMockTestEmail(String email) {
    final e = email.trim().toLowerCase();
    return e == _parentTestEmail || e == _staffTestEmail || e == _assistantTestEmail;
  }

  Future<LoginResult> jwtLogin({required String accessToken, required String refreshToken}) async {
    // TODO: replace with real API call once backend is ready
    if (accessToken == _mockParentAccessToken && refreshToken == _mockParentRefreshToken) {
      await _authRoleStore.saveRole('guardian');
      return LoginSuccess(
        user: User(id: '1', email: _parentTestEmail, username: 'TestUser', role: 'parent'),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    if (accessToken == _mockStaffAccessToken && refreshToken == _mockStaffRefreshToken) {
      await _authRoleStore.saveRole('driver');
      return LoginSuccess(
        user: User(id: '2', email: _staffTestEmail, username: 'TestStaff', role: 'driver'),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    if (accessToken == _mockAssistantAccessToken && refreshToken == _mockAssistantRefreshToken) {
      await _authRoleStore.saveRole('assistant');
      return LoginSuccess(
        user: User(
          id: '3',
          email: _assistantTestEmail,
          username: 'TestAssistant',
          role: 'assistant',
        ),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    if (!ApiConfig.useRealApi) {
      return LoginFailure("Invalid JWT");
    }

    try {
      final user = _userFromAccessToken(accessToken);
      await _authRoleStore.saveRole(user.role);
      return LoginSuccess(user: user, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      return LoginFailure("Invalid JWT");
    }
  }

  Future<ResetPasswordFlowResult> resetPassword({
    required String newPassword,
    required String otp,
    required String email,
    String? role,
  }) async {
    try {
      if (!ApiConfig.useRealApi) {
        return ResetPasswordComplete();
      }
      final authRole = role ?? await loadLastRole() ?? 'guardian';
      final response = await authData.setInitialPassword(
        role: authRole,
        email: email,
        resetToken: otp,
        newPassword: newPassword,
      );
      if (!isResOk(response)) {
        return ResetPasswordFailed('Failed to reset password. Please try again.');
      }
      final data = _extractResponseData(response);
      final accessToken = data['access'] as String?;
      final refreshToken = data['refresh'] as String?;
      if (accessToken != null &&
          refreshToken != null &&
          accessToken.isNotEmpty &&
          refreshToken.isNotEmpty) {
        await _jwtStorage.save(accessToken: accessToken, refreshToken: refreshToken);
        final user = _userFromAccessToken(
          accessToken,
          fallbackRole: authRole,
          fallbackEmail: email,
        );
        await _authRoleStore.saveRole(user.role);
        return ResetPasswordLoggedIn(
          LoginSuccess(
            user: user,
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
        );
      }
      return ResetPasswordComplete();
    } on ServerException catch (e) {
      return ResetPasswordFailed(e.message);
    } catch (e) {
      return ResetPasswordFailed(e.toString());
    }
  }

  Future<bool> logout({String? accessToken, String? refreshToken}) async {
    try {
      if (accessToken != null && refreshToken != null) {
        return await clearJWT(accessToken: accessToken, refreshToken: refreshToken);
      }
      await _authRoleStore.clear();
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
      if (!ApiConfig.useRealApi) {
        return true;
      }
      final response = await authData.logout();
      return isResOk(response);
    } on DioException catch (e) {
      throw ServerException(message: '${e.response?.data['message'] ?? 'Network error'}');
    }
  }

  Future<bool> _clearClientJWT({required String accessToken, required String refreshToken}) async {
    await _jwtStorage.clear();
    await _authRoleStore.clear();
    return true;
  }

  /// Loads tokens saved from the last successful login. Returns null if none are stored.
  Future<({String accessToken, String refreshToken})?> loadStoredTokens() => _jwtStorage.load();

  /// Removes stored tokens without contacting the server.
  Future<void> clearStoredTokens() async {
    await _jwtStorage.clear();
    await _authRoleStore.clear();
  }

  Future<OtpResult> requestOTP({
    required String role,
    required String email,
    required String password,
  }) async {
    if (!ApiConfig.useRealApi) {
      return OtpSuccess(Otp(value: 11111, duration: 90));
    }
    try {
      final response = await authData.resendOtp(role: role, email: email, password: password);
      final data = _extractResponseData(response);
      return OtpSuccess(
        Otp(
          value: (data["value"] as num?)?.toInt() ?? 0,
          duration: (data["remaining_time"] as num?)?.toInt() ?? 90,
        ),
      );
    } on ServerException catch (e) {
      return OtpFailure(e.message);
    } catch (e) {
      return OtpFailure('Otp invalid or expired.');
    }
  }

  Future<OtpResult> verifyOtp({
    required String role,
    required String email,
    required String otp,
  }) async {
    if (!ApiConfig.useRealApi) {
      return OtpVerifySuccess(
        OtpVerificationData(
          resetToken: 'mock_reset_token',
          email: email,
          requiresPasswordReset: true,
        ),
      );
    }
    try {
      final response = await authData.verifyOtp(role: role, email: email, otp: otp);
      final data = _extractResponseData(response);
      return OtpVerifySuccess(
        OtpVerificationData(
          resetToken: data['reset_token']?.toString() ?? '',
          email: data['email']?.toString() ?? email,
          requiresPasswordReset: data['requires_password_reset'] as bool? ?? true,
        ),
      );
    } on ServerException catch (e) {
      return OtpFailure(e.message);
    } catch (e) {
      return OtpFailure('Otp invalid or expired.');
    }
  }

  Future<String?> loadLastRole() => _authRoleStore.loadRole();

  Future<void> saveLastRole(String role) => _authRoleStore.saveRole(role);

  Map<String, dynamic> _extractResponseData(Response<dynamic> response) {
    final body = response.data;
    if (body is Map<String, dynamic>) {
      final dynamic data = body['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return body;
    }
    return <String, dynamic>{};
  }

  User _userFromAccessToken(
    String accessToken, {
    String fallbackRole = 'guardian',
    String fallbackEmail = '',
  }) {
    final payload = _decodeJwtPayload(accessToken);
    final roleFromToken = payload['role']?.toString() ?? payload['user_role']?.toString();
    final emailFromToken = payload['email']?.toString();
    final idFromToken = payload['user_id']?.toString() ?? payload['sub']?.toString();
    final usernameFromToken =
        payload['username']?.toString() ?? payload['name']?.toString() ?? 'SafeRoute User';
    final normalizedRole = ApiConfig.normalizeRoleForUi(roleFromToken ?? fallbackRole);

    return User(
      id: idFromToken ?? '0',
      email: emailFromToken ?? fallbackEmail,
      username: usernameFromToken,
      role: normalizedRole,
    );
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      throw const FormatException('Invalid JWT format.');
    }
    final normalizedPayload = base64Url.normalize(parts[1]);
    final payloadString = utf8.decode(base64Url.decode(normalizedPayload));
    final payload = jsonDecode(payloadString);
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    throw const FormatException('Invalid JWT payload.');
  }
}

String _loginFailureMessageFromDio(DioException e) {
  final d = e.response?.data;
  if (d is Map) {
    final msg = d['message'];
    if (msg != null && msg.toString().trim().isNotEmpty) {
      return msg.toString();
    }
    final errs = d['errors'];
    if (errs is Map) {
      for (final v in errs.values) {
        if (v is List && v.isNotEmpty) {
          return v.first.toString();
        }
      }
    }
  }
  return 'Invalid email or password.';
}

void _debugLogAuthResponse(String label, int? statusCode, Object? body) {
  if (!kDebugMode) return;
  debugPrint('[Auth] $label status=$statusCode body=${_redactTokensForLog(body)}');
}

String _redactTokensForLog(Object? data) {
  if (data == null) return 'null';
  try {
    dynamic walk(dynamic node) {
      if (node is Map) {
        final out = <String, dynamic>{};
        for (final e in node.entries) {
          final k = e.key.toString();
          final v = e.value;
          if (k == 'access' || k == 'refresh' || k == 'access_token' || k == 'refresh_token') {
            out[k] = '<redacted>';
          } else {
            out[k] = walk(v);
          }
        }
        return out;
      }
      if (node is List) {
        return node.map(walk).toList();
      }
      return node;
    }
    return jsonEncode(walk(data));
  } catch (_) {
    return data.toString();
  }
}
