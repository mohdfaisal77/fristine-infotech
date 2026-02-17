import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

final authProvider =
StateNotifierProvider<AuthViewModel, UserModel?>(
        (ref) => AuthViewModel());

class AuthViewModel extends StateNotifier<UserModel?> {
  final AuthService _service = AuthService();

  AuthViewModel() : super(null) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = await _service.getCurrentUser();
  }

  Future<bool> signup(
      String email, String password, String role) async {
    final user =
    UserModel(email: email, password: password, role: role);
    await _service.signup(user);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final user = await _service.login(email, password);
    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _service.logout();
    state = null;
  }
}
