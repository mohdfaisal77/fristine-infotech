import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import 'quiz_screen.dart';
import 'login_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../viewmodels/custom_quiz_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customQuestions = ref.watch(customQuizProvider);

    return Scaffold(
      body: Column(
        children: [
          // 🔥 HEADER
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TriviaX",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.dark_mode,
                              color: Colors.white),
                          onPressed: () {
                            themeController.toggleTheme();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout,
                              color: Colors.white),
                          onPressed: () {
                            Get.offAllNamed(AppRoutes.login);
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Choose your difficulty level",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🔥 QUIZ CARDS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildQuizCard(
                    title: "Easy",
                    icon: Icons.sentiment_satisfied,
                    color: Colors.green,
                    onTap: () =>
                        Get.toNamed(AppRoutes.quiz, arguments: "easy"),
                  ),
                  _buildQuizCard(
                    title: "Medium",
                    icon: Icons.sentiment_neutral,
                    color: Colors.orange,
                    onTap: () =>
                        Get.toNamed(AppRoutes.quiz, arguments: "medium"),
                  ),
                  _buildQuizCard(
                    title: "Hard",
                    icon: Icons.whatshot,
                    color: Colors.red,
                    onTap: () =>
                        Get.toNamed(AppRoutes.quiz, arguments: "hard"),
                  ),
                  _buildQuizCard(
                    title: "Custom",
                    icon: Icons.quiz,
                    color: Colors.deepPurple,
                    subtitle:
                    "${customQuestions.length} Questions",
                    onTap: () =>
                        Get.toNamed(AppRoutes.quiz, arguments: "custom"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CARD WIDGET
  Widget _buildQuizCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

