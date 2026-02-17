import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'admin_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      final user = ref.read(authProvider);
      if (user!.role == "admin") {
        Get.offAll(() => AdminDashboard());
      } else {
        Get.offAll(() => HomeScreen());
      }
    } else {
      Get.snackbar(
        "Login Failed",
        "Invalid email or password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/crm.png",
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Welcome Back 👋",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    /// Email
                    CustomTextField(
                      controller: emailController,
                      hint: "Email",
                      validator: validateEmail,
                    ),

                    /// Password
                    CustomTextField(
                      controller: passwordController,
                      hint: "Password",
                      isPassword: true,
                      validator: validatePassword,
                    ),

                    const SizedBox(height: 20),

                    PrimaryButton(
                      text: "Login",
                      onPressed: login,
                    ),

                    TextButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.signUp),
                      child: const Text("Create Account"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

