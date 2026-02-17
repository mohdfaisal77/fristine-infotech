import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/routes/app_routes.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'admin_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      final user = ref.read(authProvider);

      if (user == null) {
        Get.offAll(() => const LoginScreen());
      } else {
        if (user.role == "admin") {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                "assets/animations/crm.json",
                height: 150,
              ),
            ),
            // Image.asset(
            //   "assets/images/crm.png",
            //   height: 200,
            // ),
            const SizedBox(height: 30),
            const Text(
              "TriviaX",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
