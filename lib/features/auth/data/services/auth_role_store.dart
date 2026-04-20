import 'package:shared_preferences/shared_preferences.dart';

class AuthRoleStore {
  static const String _authRoleKey = 'auth_role';

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authRoleKey, role);
  }

  Future<String?> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authRoleKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authRoleKey);
  }
}
