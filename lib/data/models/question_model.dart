class QuestionModel {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      incorrectAnswers:
      List<String>.from(json['incorrectAnswers'] ?? []),
    );
  }

  // ✅ ADD THIS (VERY IMPORTANT)
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
    };
  }

  List<String> getShuffledOptions() {
    final options = [...incorrectAnswers, correctAnswer];
    options.shuffle();
    return options;
  }
}

