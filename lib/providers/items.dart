import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:broom/helpers/dbHelper.dart';

import '../assets/orderCategory.dart';
import './item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get itemsRandom {
    var items = [..._items];
    items.shuffle();
    return items;
  }

  Future<void> fetchAndSetItems() async {
    print("fetching");
    final itemsList = await DBHelper.getData('items');
    final answersList = await DBHelper.getData('answers');

    var dbItems = itemsList.map((item) {
      Map<String, double> answers = {};
      answersList
          .where((a) => a["itemId"] == item["id"])
          .toList()
          .forEach((answer) {
        answers[answer["id"]] = answer["answer"];
      });
      return Item(
        title: item["title"],
        description: item["description"],
        id: item["id"],
        imgUrl: item["imgPath"],
        answers: answers,
        date: DateTime.now(),
      );
    }).toList();

    _items = dbItems;

    notifyListeners();
  }

  void addItem(String title, String description, String imgPath) {
    var id = DateTime.now().toString();

    _items.add(Item(
      title: title,
      description: description,
      imgUrl: imgPath,
      date: DateTime.now(),
      id: id,
    ));

    notifyListeners();
    DBHelper.insert("items", {
      "id": id,
      "description": description,
      "title": title,
      "imgPath": imgPath,
    });
  }

  void updateItem(String id, String title, String description, String imgPath) {
    var item = _items.firstWhere((i) => i.id == id);
    item.title = title;
    item.description = description;

    notifyListeners();
    DBHelper.insert("items", {
      "id": id,
      "description": description,
      "title": title,
      "imgPath": imgPath,
    });
  }

  List<Item> getItemsByOrderAndSearchQuery(
      OrderCategory order, String searchQuery) {
    var items = [..._items];

    if (searchQuery != "") {
      items = items.where((item) => item.title.contains(searchQuery)).toList();
    }

    switch (order) {
      case OrderCategory.latest:
        items.sort((a, b) => b.date.compareTo(a.date));
        return items;
        break;
      case OrderCategory.alphabetical:
        items.sort((a, b) => a.title[0].compareTo(b.title[0]));
        return items;
        break;
      default:
        return items;
    }
  }

  Item findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void deleteItem(String id) {
    _items.removeWhere((item) {
      return (item.id == id);
    });

    notifyListeners();
    DBHelper.deleteItemAndItemAnswers(id);
  }
}
