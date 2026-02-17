import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = "user";

  void signup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).signup(
      emailController.text.trim(),
      passwordController.text.trim(),
      role,
    );

    Get.back();
    Get.snackbar(
      "Success",
      "Account Created Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: role,
                      items: const [
                        DropdownMenuItem(
                            value: "user", child: Text("User")),
                        DropdownMenuItem(
                            value: "admin", child: Text("Admin")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          role = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a role";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select Role",
                      ),
                    ),

                    const SizedBox(height: 20),

                    PrimaryButton(
                      text: "Signup",
                      onPressed: signup,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.login),
                      child: const Text("Already have an Account? "),
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

