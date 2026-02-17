import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _usersKey = "users";
  static const _currentUserKey = "current_user";

  Future<void> signup(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];

    users.add(jsonEncode(user.toJson()));
    await prefs.setStringList(_usersKey, users);
  }

  Future<UserModel?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];

    for (var u in users) {
      final decoded = jsonDecode(u);
      if (decoded['email'] == email &&
          decoded['password'] == password) {
        await prefs.setString(_currentUserKey, u);
        return UserModel.fromJson(decoded);
      }
    }
    return null;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(_currentUserKey);
    if (user == null) return null;
    return UserModel.fromJson(jsonDecode(user));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
