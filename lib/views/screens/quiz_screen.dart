import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import '../../viewmodels/custom_quiz_viewmodel.dart';
import '../widgets/life_indicator.dart';
import '../widgets/option_card.dart';
import 'result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String mode;
  const QuizScreen(this.mode, {super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final quizNotifier = ref.read(quizProvider.notifier);

      if (widget.mode == "custom") {
        final customQuestions = ref.read(customQuizProvider);

        final Map<int, List<String>> optionsMap = {};

        for (int i = 0; i < customQuestions.length; i++) {
          optionsMap[i] = customQuestions[i].getShuffledOptions();
        }

        quizNotifier.state = quizNotifier.state.copyWith(
          questions: customQuestions,
          currentIndex: 0,
          score: 0,
          lives: 3,
          isFinished: false,
          isLoading: false,
          selectedAnswer: null,
          shuffledOptions: optionsMap, // 👈 IMPORTANT
        );
      }
      else {
        quizNotifier.loadQuestions(widget.mode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final customQuestions = ref.watch(customQuizProvider);

    final questions =
    widget.mode == "custom" ? customQuestions : quizState.questions;
// 🔥 PROTECTION 1: Loading
    if (widget.mode != "custom" && quizState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

// 🔥 PROTECTION 2: No questions at all
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            widget.mode == "custom"
                ? "No custom questions created yet"
                : "Loading questions...",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

// 🔥 PROTECTION 3: Index safety
    if (quizState.currentIndex >= questions.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // API loading
    if (widget.mode != "custom" && quizState.isLoading) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            "assets/animations/loading.json",
            height: 150,
          ),
        ),
      );
    }

    if (widget.mode == "custom" && questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No custom questions created yet",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (quizState.isFinished) {
      Future.microtask(() {
        ref.read(quizProvider.notifier).resetQuiz();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(score: quizState.score),
          ),
        );
      });
    }
    final current = questions[quizState.currentIndex];

    // final current = quizState.questions[quizState.currentIndex];
    final options =
        quizState.shuffledOptions[quizState.currentIndex] ?? [];

    double progress =
        (quizState.currentIndex + 1) / quizState.questions.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Question ${quizState.currentIndex + 1}/${quizState.questions.length}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Score: ${quizState.score}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor:
                    const AlwaysStoppedAnimation(Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 LIVES
            LifeIndicator(lives: quizState.lives),

            const SizedBox(height: 20),

            // 🔥 QUESTION CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                child: Text(
                  current.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 OPTIONS
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];

                  final isSelected =
                      quizState.selectedAnswer == option;

                  final isCorrect =
                      option == current.correctAnswer;

                  final hasAnswered =
                      quizState.selectedAnswer != null;

                  return AnimatedOpacity(
                    duration:
                    Duration(milliseconds: 300 + (index * 100)),
                    opacity: 1,
                    child: OptionCard(
                      text: option,
                      isSelected: isSelected,
                      isCorrect: isCorrect,
                      hasAnswered: hasAnswered,
                      onTap: () {
                        ref
                            .read(quizProvider.notifier)
                            .answer(option);
                      },
                    ),
                  );
                },
              ),
            ),

            // 🔥 SKIP BUTTON
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(quizProvider.notifier)
                        .skipQuestion();
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text("Skip Question"),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
