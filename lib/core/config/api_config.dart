class ApiConfig {
  static const String _defaultBaseUrl = 'http://localhost:5000';
  static const String _apiVersionPrefix = '/api/v1';

  static const bool useRealApi = false;

  static const String _rawBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get baseUrl => _trimTrailingSlash(_rawBaseUrl);

  static String get apiBasePath => '$baseUrl$_apiVersionPrefix';

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
