import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../assets/questionCategory.dart';
import './question.dart';

class Questions with ChangeNotifier {
  List<Question> _questions = [
    Question(
      id: "1",
      text: "Did you use this in the past week?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "2",
      text: "Did you use this in the past month?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "3",
      text: "Did you use this in the past year?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "4",
      text: "Is this in good shape?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "5",
      text: "Are you holding on to this for sentimental reasons?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "6",
      text: "Are you holding on to this just in case?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "7",
      text: "Would you buy this again?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "8",
      text: "Can you survive just fine without this?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "9",
      text: "Is this holding you back from something?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "10",
      text: "Is this just for decoration?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "11",
      text: "Do you own something else that fulfills this items purpose?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "12",
      text: "Does this add value to your life?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "13",
      text: "Does this solve a specific problem?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "14",
      text: "If you would move today: Would you take this with you?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "15",
      text: "Do you mind cleaning this?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "16",
      text: "Do you mind the space you need for storing this?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "17",
      text: "Would it be possible and convenient to borrow this from a friend of neighboor?",
      category: QuestionCategory.use,
    ),
    Question(
      id: "18",
      text: "If a friend would wish for this for birthday, would you give it away?",
      category: QuestionCategory.use,
    ),
  ];

  List<Question> get questions {
    var questions = [..._questions];
    return questions;
  }

  Question findUnanswered(List<String> answeredIds) {
    _questions.shuffle();
    return _questions.firstWhere((q) => !answeredIds.contains(q.id));
  }

  Question findRandom() {
    _questions.shuffle();
    return _questions.first;
  }

  Question findById(String id) {
    return _questions.firstWhere((q) => q.id == id);
  }
}
