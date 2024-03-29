import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'item.dart';

enum Answer {
  Yes,
  No,
}

enum QuestionCategory {
  Ownership,
  Usage,
  Attachment,
}

class Question extends Equatable {
  final int id;
  final String category;
  final String text;
  final int answerIndicatingValue;

  Question({
    @required this.id,
    @required this.category,
    @required this.text,
    @required this.answerIndicatingValue,
  });

  @override
  List<Object> get props => [
        id,
        category,
        text,
        answerIndicatingValue,
      ];
}
