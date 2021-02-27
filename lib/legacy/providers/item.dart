import 'package:flutter/foundation.dart';

import '../helpers/dbHelper.dart';

class Item {
  String id;
  String title;
  String description;
  String imgUrl;
  Map<String, double> answers = {};
  DateTime date;

  void addAnswer(double answer, String id, String itemId) {
    answers[id] = answer;
    DBHelper.insert("answers", {"id": id, "itemId": itemId, "answer": answer});
  }

  Item({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imgUrl,
    this.answers,
    @required this.date,
  });
}
