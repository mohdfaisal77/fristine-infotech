import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/question_model.dart';

final customQuizProvider =
StateNotifierProvider<CustomQuizViewModel, List<QuestionModel>>(
        (ref) => CustomQuizViewModel());

class CustomQuizViewModel extends StateNotifier<List<QuestionModel>> {
  static const _storageKey = "custom_questions";

  CustomQuizViewModel() : super([]) {
    loadQuestions();
  }

  // LOAD QUESTIONS FROM STORAGE
  Future<void> loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);

    if (stored == null || stored.isEmpty) {
      state = [];
      return;
    }

    state = stored
        .map((e) => QuestionModel.fromJson(jsonDecode(e)))
        .toList();
  }

  //  SAVE QUESTIONS TO STORAGE
  Future<void> _saveQuestions() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = state
        .map((question) => jsonEncode(question.toJson()))
        .toList();

    await prefs.setStringList(_storageKey, encoded);
  }

  // ADD QUESTION
  Future<void> addQuestion(QuestionModel question) async {
    if (state.length >= 10) return;

    state = [...state, question];
    await _saveQuestions();
  }

  Future<void> editQuestion(int index, QuestionModel question) async {
    final updated = [...state];
    updated[index] = question;
    state = updated;
    await _saveQuestions();
  }


  //  DELETE QUESTION
  Future<void> deleteQuestion(int index) async {
    final updated = [...state];
    updated.removeAt(index);
    state = updated;
    await _saveQuestions();
  }

  //  CLEAR ALL QUESTIONS
  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
