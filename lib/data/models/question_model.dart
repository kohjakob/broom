import 'package:broom/domain/entities/question.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/item.dart';

class QuestionModel extends Question {
  final int id;
  final String category;
  final String text;
  final int answerIndicatingValue;

  QuestionModel({
    @required this.id,
    @required this.category,
    @required this.text,
    @required this.answerIndicatingValue,
  }) : super(
          id: id,
          category: category,
          text: text,
          answerIndicatingValue: answerIndicatingValue,
        );

  @override
  List<Object> get props => [
        id,
        category,
        text,
        answerIndicatingValue,
      ];
}
