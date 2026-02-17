import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/helpers.dart';

class CustomTextField extends ConsumerWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final String? Function(String?)? validator; // ✅ FIXED

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscure = ref.watch(passwordVisibilityProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        validator: validator, // ✅ Now compatible
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              ref.read(passwordVisibilityProvider.notifier).state =
              !obscure;
            },
          )
              : null,
        ),
      ),
    );
  }
}

