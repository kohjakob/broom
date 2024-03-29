import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/room_detail_cubit.dart';
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Text("Really delete this room?"),
      contentPadding: EdgeInsets.fromLTRB(10, 20, 30, 10),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (widget.room.items.length > 0)
                ? Row(
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
                : Container(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        TextButton(
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

  _editRoom(BuildContext context) {
    context.read<RoomDetailCubit>().setRoom(state.roomSelected);
    Navigator.of(context).pushNamed(EditRoomFormPage.routeName);
  }

  _deleteRoomDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) => DeleteRoomDialog(state.roomSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
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
