import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/custom_quiz_viewmodel.dart';
import '../../data/models/question_model.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'package:get/get.dart';


class AdminDashboard extends ConsumerWidget {
  AdminDashboard({super.key});
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(customQuizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Get.offAllNamed(AppRoutes.login);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.adminScreen);
        },
        child: const Icon(Icons.add),
      ),
      body: questions.isEmpty
          ? const Center(child: Text("No Questions Created Yet"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(question.question),
              subtitle: Text(
                  "Correct: ${question.correctAnswer}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.blue),
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.adminScreen,
                        arguments: {
                          "question": question,
                          "index": index,
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.red),
                    onPressed: () {
                      ref
                          .read(customQuizProvider.notifier)
                          .deleteQuestion(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final questionController = TextEditingController();
  final optionControllers =
  List.generate(4, (index) => TextEditingController());

  int correctIndex = 0;
  int? editingIndex; // 🔥 important

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args != null) {
      final QuestionModel question = args["question"];
      editingIndex = args["index"];

      questionController.text = question.question;

      final options = [
        ...question.incorrectAnswers,
        question.correctAnswer
      ];

      for (int i = 0; i < 4; i++) {
        optionControllers[i].text = options[i];
        if (options[i] == question.correctAnswer) {
          correctIndex = i;
        }
      }
    }
  }

  void saveQuestion() async {
    final questionText = questionController.text.trim();

    // 1️⃣ Validate Question
    if (questionText.isEmpty || questionText.length < 5) {
      Get.snackbar(
        "Invalid Question",
        "Question must contain at least 5 characters",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2️⃣ Validate Options
    List<String> options =
    optionControllers.map((e) => e.text.trim()).toList();

    if (options.any((element) => element.isEmpty)) {
      Get.snackbar(
        "Invalid Options",
        "All 4 options must be filled",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 3️⃣ Prevent duplicate options
    if (options.toSet().length != options.length) {
      Get.snackbar(
        "Duplicate Options",
        "Options must be unique",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 4️⃣ Ensure correct answer has text
    if (options[correctIndex].isEmpty) {
      Get.snackbar(
        "Invalid Correct Answer",
        "Correct answer cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final question = QuestionModel(
      question: questionText,
      correctAnswer: options[correctIndex],
      incorrectAnswers: options
          .asMap()
          .entries
          .where((e) => e.key != correctIndex)
          .map((e) => e.value)
          .toList(),
    );

    if (editingIndex != null) {
      await ref
          .read(customQuizProvider.notifier)
          .editQuestion(editingIndex!, question);
    } else {
      await ref
          .read(customQuizProvider.notifier)
          .addQuestion(question);
    }

    Get.back();

    Get.snackbar(
      "Success",
      editingIndex != null
          ? "Question Updated Successfully"
          : "Question Added Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            editingIndex != null ? "Edit Question" : "Create Question"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: questionController,
              hint: "Enter Question",
            ),
            const SizedBox(height: 20),

            for (int i = 0; i < 4; i++)
              Row(
                children: [
                  Radio(
                    value: i,
                    groupValue: correctIndex,
                    onChanged: (value) {
                      setState(() {
                        correctIndex = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: optionControllers[i],
                      hint: "Option ${i + 1}",
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            PrimaryButton(
              text: editingIndex != null
                  ? "Update Question"
                  : "Add Question",
              onPressed: saveQuestion,
            ),
          ],
        ),
      ),
    );
  }
}

