import 'package:flutter_riverpod/legacy.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/services/api_service.dart';

final quizProvider =
StateNotifierProvider<QuizViewModel, QuizState>((ref) {
  return QuizViewModel(
    QuizRepository(ApiService()),
  );
});

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int lives;
  final bool isFinished;
  final bool isLoading;
  final String? selectedAnswer;
  final Map<int, List<String>> shuffledOptions; // 👈 ADD

  QuizState({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.lives,
    required this.isFinished,
    required this.isLoading,
    required this.selectedAnswer,
    required this.shuffledOptions,
  });

  factory QuizState.initial() => QuizState(
    questions: [],
    currentIndex: 0,
    score: 0,
    lives: 3,
    isFinished: false,
    isLoading: false,
    selectedAnswer: null,
    shuffledOptions: {}, // 👈 ADD
  );

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? lives,
    bool? isFinished,
    bool? isLoading,
    String? selectedAnswer,
    bool clearSelectedAnswer = false,
    Map<int, List<String>>? shuffledOptions,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isFinished: isFinished ?? this.isFinished,
      isLoading: isLoading ?? this.isLoading,
      selectedAnswer:
      clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      shuffledOptions: shuffledOptions ?? this.shuffledOptions,
    );
  }


}

class QuizViewModel extends StateNotifier<QuizState> {
  final QuizRepository repository;

  QuizViewModel(this.repository) : super(QuizState.initial());

  // LOAD QUESTIONS WITH LOADING STATE
  Future<void> loadQuestions(String difficulty) async {
    state = state.copyWith(isLoading: true);

    final questions = await repository.getQuestions(difficulty);

    final Map<int, List<String>> optionsMap = {};

    for (int i = 0; i < questions.length; i++) {
      optionsMap[i] = questions[i].getShuffledOptions();
    }

    state = state.copyWith(
      questions: questions,
      currentIndex: 0,
      score: 0,
      lives: 3,
      isFinished: false,
      isLoading: false,
      selectedAnswer: null,
      shuffledOptions: optionsMap,
    );
  }


  // ANSWER LOGIC WITH VISUAL FEEDBACK
  void answer(String selected) {
    if (state.selectedAnswer != null || state.isFinished) return;

    final current = state.questions[state.currentIndex];

    int updatedScore = state.score;
    int updatedLives = state.lives;

    state = state.copyWith(selectedAnswer: selected);

    if (selected == current.correctAnswer) {
      updatedScore += 10;
    } else {
      updatedLives -= 1;

      if (updatedLives <= 0) {
        state = state.copyWith(
          lives: 0,
          isFinished: true,
        );
        return;
      }
    }

    state = state.copyWith(
      score: updatedScore,
      lives: updatedLives,
    );

    // 🔥 Delay + move next question here
    Future.delayed(const Duration(seconds: 1), () {
      if (state.currentIndex + 1 >= state.questions.length) {
        state = state.copyWith(
          isFinished: true,
          clearSelectedAnswer: true,
        );
      } else {
        state = state.copyWith(
          currentIndex: state.currentIndex + 1,
          clearSelectedAnswer: true, // 🔥 THIS IS THE FIX
        );
      }
    });

  }

  bool mountedStateSafe() {
    return !state.isFinished &&
        state.currentIndex < state.questions.length;
  }


  // 🔥 SKIP LOGIC
  void skipQuestion() {
    if (state.score > 0) {
      state = state.copyWith(score: state.score - 5);
    }

    nextQuestion();
  }

  // NEXT QUESTION
  void nextQuestion() {
    if (state.currentIndex + 1 >= state.questions.length) {
      state = state.copyWith(isFinished: true);
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedAnswer: null,
      );
    }
  }


  // 🔥 RESET QUIZ
  void resetQuiz() {
    state = QuizState.initial();
  }

  // 🔥 CELEBRATION CONDITION
  bool shouldCelebrate() {
    return state.score >= 60;
  }
}
