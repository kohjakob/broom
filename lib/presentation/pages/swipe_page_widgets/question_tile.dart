import 'package:broom/domain/entities/question.dart';
import 'package:flutter/material.dart';

class QuestionTile extends StatelessWidget {
  final Question question;
  const QuestionTile(this.question);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          color: Colors.indigo.shade50,
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              question.text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.indigo.shade500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
