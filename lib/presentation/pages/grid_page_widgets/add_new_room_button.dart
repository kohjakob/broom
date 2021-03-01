import 'package:broom/presentation/bloc/room_detail_cubit.dart';
import 'package:flutter/material.dart';

import '../add_room_form_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewRoomButton extends StatelessWidget {
  AddNewRoomButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 10, 1),
      child: ButtonTheme(
        minWidth: 10,
        child: FlatButton(
          shape: StadiumBorder(),
          onPressed: () {
            context.read<RoomDetailCubit>().setEmptyRoom();
            Navigator.of(context).pushNamed(AddRoomFormPage.routeName);
          },
          color: Theme.of(context).accentColor,
          child: Text(
            "Add Room",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
