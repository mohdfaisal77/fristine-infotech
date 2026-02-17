import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {

  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);

    _scaleController.forward();

    if (widget.score >= 60) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool celebrate = widget.score >= 60;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            // 🎉 Confetti
            if (celebrate)
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
              ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                if (celebrate)
                  Lottie.asset(
                    "assets/animations/celebration.json",
                    height: 160,
                  ),

                const SizedBox(height: 20),

                const Text(
                  "Quiz Completed 🎯",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔥 Animated Score Circle
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Colors.deepPurple,
                          Colors.purpleAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.purple.withOpacity(0.4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "${widget.score}",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  widget.score >= 60
                      ? "Excellent Performance 🚀"
                      : "Keep Practicing 💪",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Back to Home"),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}

