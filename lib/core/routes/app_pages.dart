import 'package:fristine_infotech/views/screens/signup_screen.dart';
import 'package:get/get.dart';
import '../../views/screens/admin_screen.dart';
import '../../views/screens/splash_screen.dart';
import '../../views/screens/login_screen.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/quiz_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignupScreen(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),

    GetPage(
      name: AppRoutes.adminScreen,
      page: () => const AdminScreen(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () =>  AdminDashboard(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () {
        final difficulty = Get.arguments ?? "easy";
        return QuizScreen(difficulty);
      },
    ),
  ];
}
