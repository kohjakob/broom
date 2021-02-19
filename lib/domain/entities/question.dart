import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum Answer {
  Yes,
  No,
}

enum Category {
  Ownership,
  Usage,
  Attachment,
}

class Question extends Equatable {
  final Category category;
  final String text;
  // The answer to give if one agrees
  final Answer answerToAgree;

  Question({
    @required this.category,
    @required this.text,
    @required this.answerToAgree,
  });

  @override
  List<Object> get props => [category, text, answerToAgree];
}
