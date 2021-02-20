import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/question.dart';
import '../providers/items.dart';
import '../providers/item.dart';
import '../providers/questions.dart';
import '../widgets/detailImageBar.dart';
import '../assets/constants.dart' as Constants;
import 'package:intl/intl.dart';

class Details extends StatelessWidget {
  static const routeName = "/details";

  List<Widget> _buildAnswerTiles(Item item, Questions questions) {
    if (item.answers != null) {
      List<Widget> answerTiles = [];
      item.answers.forEach((key, value) {
        Question question = questions.findById(key);

        Widget tile = Container(
          color: value > 0.5 ? Colors.lightGreen.shade400 : Colors.red.shade400,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question.text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              value > 0.5
                  ? Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.thumb_down,
                      color: Colors.white,
                    ),
            ],
          ),
        );
        answerTiles.add(tile);
      });
      return answerTiles;
    } else {
      return [Text("You didn't answer any questions for this item yet.")];
    }
  }

  @override
  Widget build(context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final item = Provider.of<Items>(context, listen: false).findById(id);
    final questions = Provider.of<Questions>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              ImageBar(item),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(Constants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "Added: ${DateFormat('MM/dd/yy').format(item.date)}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          Text(
                            "Answers",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 10),
                          ..._buildAnswerTiles(item, questions),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
