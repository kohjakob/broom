import 'package:flutter/foundation.dart';

import '../assets/questionCategory.dart';

class Question {
  String id;
  String text;
  QuestionCategory category;

  Question({
    @required this.id,
    @required this.text,
    @required this.category,
  });
}
