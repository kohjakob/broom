import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  const Question({
    Key key,
  }) : super(key: key);

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
          child: Text(
            "Did you use this item in the last week?",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.indigo.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
