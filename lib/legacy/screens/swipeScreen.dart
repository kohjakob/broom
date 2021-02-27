import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item.dart';
import '../providers/items.dart';
import '../providers/question.dart';
import '../providers/questions.dart';
import '../widgets/swipeInstance.dart';

class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  List<Item> items;
  List<Item> paintItems;
  int itemZIndex;
  Items _items;
  Questions _questions;
  bool isInit = false;
  Question question;
  bool notEmptyItems = false;

  _popItem() {
    setState(() {
      items.removeAt(items.length - 1);
    });
  }

  @override
  Widget build(context) {
    _items = Provider.of<Items>(context);
    _questions = Provider.of<Questions>(context);

    if (!isInit) {
      setState(() {
        items = _items.itemsRandom;
        isInit = true;
      });

      if (items.isNotEmpty) {
        setState(() {
          notEmptyItems = true;
        });
      }
    }
    itemZIndex = -items.length;

    return Stack(
      children: [
        notEmptyItems
            ? Center(
                child: OutlineButton(
                  child: Text("Reload"),
                  onPressed: () => setState(() {
                    items = _items.itemsRandom;
                  }),
                ),
              )
            : items.isEmpty
                ? Center(child: Text("You didn't add any items yet."))
                : Container(),
        ...items.map(
          (item) {
            itemZIndex += 1;

            if (item.answers != null) {
              if (item.answers.length != _questions.questions.length) {
                question =
                    _questions.findUnanswered(item.answers.keys.toList());
              } else {
                return Container();
              }
            } else {
              question = _questions.findRandom();
            }

            return SwipeInstance(item, itemZIndex, question, _popItem);
          },
        ).toList(),
      ],
    );
  }
}
