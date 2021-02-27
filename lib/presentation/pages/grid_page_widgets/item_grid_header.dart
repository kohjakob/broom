import 'package:flutter/material.dart';

import '../../bloc/grid_cubit.dart';
import '../edit_room_form_page.dart';

class ItemGridHeader extends StatelessWidget {
  final GridLoaded state;
  const ItemGridHeader(this.state);

  _editRoom(context) {
    Navigator.of(context).pushNamed(EditRoomFormPage.routeName,
        arguments: {"roomToEdit": state.roomSelected});
  }

  _deleteRoomDialog(context) {
    final deleteDialog = AlertDialog(
      title: Text("Really delete this room?"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(value: false, onChanged: null),
                Expanded(child: Text("Delete all items in this room"))
              ],
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("No")),
        FlatButton(onPressed: null, child: Text("Yes")),
      ],
    );
    showDialog(context: context, child: deleteDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              (state.roomSelected == null)
                  ? state.displayItems.length == 0
                      ? "No items yet"
                      : "All your items"
                  : state.roomSelected.name,
              style: Theme.of(context).textTheme.headline5),
          Row(
            children: (state.roomSelected == null)
                ? []
                : [
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editRoom(context)),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteRoomDialog(context)),
                  ],
          )
        ],
      ),
    );
  }
}
