import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fristine_infotech/views/screens/admin_screen.dart';
import 'package:fristine_infotech/views/screens/home_screen.dart';
import 'package:fristine_infotech/views/screens/login_screen.dart';
import 'package:fristine_infotech/views/screens/quiz_screen.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'views/screens/splash_screen.dart';
void main() {
  Get.put(ThemeController());
  runApp(const ProviderScope(child: TriviaX()));
}

class TriviaX extends StatelessWidget {
  const TriviaX({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
