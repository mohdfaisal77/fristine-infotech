import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final passwordVisibilityProvider =
StateProvider<bool>((ref) => true); // true = obscure



String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email cannot be empty";
  }

  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if (!emailRegex.hasMatch(value)) {
    return "Enter valid email address";
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password cannot be empty";
  }

  if (value.length < 6) {
    return "Password must be at least 6 characters";
  }

  final hasNumber = RegExp(r'[0-9]').hasMatch(value);
  final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  if (!hasNumber) {
    return "Password must include at least one number";
  }

  if (!hasSpecial) {
    return "Password must include at least one special character";
  }

  return null;
}

