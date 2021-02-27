import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../assets/constants.dart' as Constants;
import '../screens/detailsScreen.dart';

class GridItem extends StatelessWidget {
  final BoxConstraints constraints;
  final String title;
  final DateTime date;
  final String imgUrl;
  final String id;
  GridItem(this.constraints, this.title, this.date, this.imgUrl, this.id);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(Details.routeName, arguments: id),
      child: Container(
        decoration: BoxDecoration(),
        child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(Constants.defaultBorderRadius)),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Image.file(
                  File(imgUrl),
                  height: constraints.maxWidth,
                  width: constraints.maxWidth,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.grey.shade200,
                width: constraints.maxWidth,
                height: constraints.maxHeight - constraints.maxWidth,
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      DateFormat("MM/dd/yy").format(date),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
