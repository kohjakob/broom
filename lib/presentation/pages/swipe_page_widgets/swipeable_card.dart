import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:flutter/material.dart';

class SwipeableCard extends StatelessWidget {
  final Item item;
  SwipeableCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: (item.imagePath != null)
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(item.imagePath)),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
            child: Column(
              children: [
                Expanded(
                  child: (item.imagePath == null)
                      ? Icon(
                          Icons.image,
                          color: Theme.of(context).accentColor.withAlpha(100),
                          size: 220,
                        )
                      : Container(),
                ),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.fromLTRB(30, 25, 30, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
