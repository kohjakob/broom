import 'package:flutter/material.dart';

import '../add_room_form_page.dart';

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
          onPressed: () =>
              Navigator.of(context).pushNamed(AddRoomFormPage.routeName),
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
