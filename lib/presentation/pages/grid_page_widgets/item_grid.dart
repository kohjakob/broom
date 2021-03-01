import 'package:flutter/material.dart';

import '../../bloc/grid_cubit.dart';
import 'add_new_item_tile.dart';
import 'item_tile.dart';

class ItemGrid extends StatelessWidget {
  final GridLoaded state;
  ItemGrid(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          AddNewItemTile(state.roomSelected),
          ...state.displayItems
              .where((displayItem) {
                return (displayItem.searchMatch && displayItem.roomFilterMatch);
              })
              .toList()
              .map((item) => ItemTile(
                  item,
                  state.rooms
                      .firstWhere((room) => room.id == item.item.roomId)))
              .toList()
        ],
      ),
    );
  }
}
