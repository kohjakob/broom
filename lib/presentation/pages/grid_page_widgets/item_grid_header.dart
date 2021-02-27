import 'package:broom/domain/entities/room.dart';
import 'package:broom/domain/usecases/delete_room.dart';
import 'package:flutter/material.dart';

import '../../bloc/grid_cubit.dart';
import '../edit_room_form_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteRoomDialog extends StatefulWidget {
  final Room room;
  DeleteRoomDialog(this.room);

  @override
  _DeleteRoomDialogState createState() => _DeleteRoomDialogState();
}

class _DeleteRoomDialogState extends State<DeleteRoomDialog> {
  bool deleteAllRooms;

  @override
  void initState() {
    deleteAllRooms = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Really delete this room?"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(
                  value: deleteAllRooms,
                  onChanged: (value) {
                    setState(
                      () {
                        deleteAllRooms = value;
                      },
                    );
                  },
                ),
                Expanded(child: Text("Delete all items in this room"))
              ],
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        FlatButton(
          onPressed: () {
            if (deleteAllRooms) {
              context.read<GridCubit>().deleteRoomAndItems(widget.room.id);
              Navigator.of(context).pop();
            } else {
              context.read<GridCubit>().deleteRoomKeepItems(widget.room.id);
              Navigator.of(context).pop();
            }
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}

class ItemGridHeader extends StatelessWidget {
  final GridLoaded state;
  const ItemGridHeader(this.state);

  _editRoom(context) {
    Navigator.of(context).pushNamed(EditRoomFormPage.routeName,
        arguments: {"roomToEdit": state.roomSelected});
  }

  _deleteRoomDialog(context) async {
    await showDialog(
        context: context, child: DeleteRoomDialog(state.roomSelected));
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
