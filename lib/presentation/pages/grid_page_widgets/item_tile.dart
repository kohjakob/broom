import 'dart:io';

import 'package:flutter/material.dart';

import '../../bloc/grid_cubit.dart';
import '../item_detail_page.dart';

class ItemTile extends StatelessWidget {
  final DisplayItem displayItem;
  ItemTile(this.displayItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(ItemDetailPage.routeName, arguments: {
        "item": displayItem.item,
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Theme.of(context).primaryColor.withAlpha(15),
          child: Column(
            children: [
              displayItem.item.imagePath != null
                  ? Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(30),
                          image: DecorationImage(
                            image: FileImage(
                              File(displayItem.item.imagePath),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: Theme.of(context).primaryColor.withAlpha(15),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        displayItem.item.name,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
