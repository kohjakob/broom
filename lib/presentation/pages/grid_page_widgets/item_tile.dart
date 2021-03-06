import 'dart:io';

import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:flutter/material.dart';

import '../item_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemTile extends StatelessWidget {
  final displayItem;
  final room;
  ItemTile(this.displayItem, this.room);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ItemDetailCubit>().setItem(
              displayItem.item,
              room.id,
            );
        Navigator.of(context).pushNamed(ItemDetailPage.routeName);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Theme.of(context).primaryColor.withAlpha(15),
          child: Column(
            children: [
              displayItem.item.imagePath != null
                  ? Flexible(
                      flex: 3,
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
                  padding: EdgeInsets.all(5),
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
