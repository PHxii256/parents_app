class ApiConfig {
  /// SafeRoute backend (override with `--dart-define=API_BASE_URL=https://...`).
  static const String _defaultBaseUrl = 'http://37.27.204.174:8000';
  static const String _apiVersionPrefix = '/api/v1';

  /// Runtime-toggleable API mode. Defaults to real API unless overridden at build time.
  static const bool _defaultUseRealApi = bool.fromEnvironment(
    'USE_REAL_API',
    defaultValue: true,
  );
  static bool _useRealApi = _defaultUseRealApi;

  static const String _rawBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get baseUrl => _trimTrailingSlash(_rawBaseUrl);
  static bool get useRealApi => _useRealApi;

  static String get apiBasePath => '$baseUrl$_apiVersionPrefix';

  static bool toggleUseRealApi() {
    _useRealApi = !_useRealApi;
    return _useRealApi;
  }

  static String roleAuthPathSegment(String role) {
    switch (role.trim().toLowerCase()) {
      case 'parent':
      case 'guardian':
        return 'guardian';
      case 'driver':
        return 'driver';
      case 'assistant':
      case 'bus_staff':
      case 'staff':
        return 'assistant';
      default:
        return 'guardian';
    }
  }

  static String normalizeRoleForUi(String role) {
    switch (role.trim().toLowerCase()) {
      case 'guardian':
        return 'parent';
      case 'bus_staff':
      case 'staff':
        return 'assistant';
      default:
        return role.trim().toLowerCase();
    }
  }

  static String _trimTrailingSlash(String value) {
    var trimmed = value.trim();
    while (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
