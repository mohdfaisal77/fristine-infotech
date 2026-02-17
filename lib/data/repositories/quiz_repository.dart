import '../models/question_model.dart';
import '../services/api_service.dart';

class QuizRepository {
  final ApiService apiService;

  QuizRepository(this.apiService);

  Future<List<QuestionModel>> getQuestions(String difficulty) {
    return apiService.fetchQuestions(difficulty);
  }
}
