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
        child: TextButton(
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
            shape: MaterialStateProperty.all(StadiumBorder()),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).accentColor),
          ),
          onPressed: () {
            context.read<RoomDetailCubit>().setEmptyRoom();
            Navigator.of(context).pushNamed(AddRoomFormPage.routeName);
          },
          child: Text(
            "Add Room",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
