import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class ApiService {
  Future<List<QuestionModel>> fetchQuestions(String difficulty) async {
    final url =
        'https://the-trivia-api.com/api/questions?limit=10&difficulty=$difficulty';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => QuestionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
