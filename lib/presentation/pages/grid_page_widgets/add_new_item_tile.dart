import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../domain/entities/room.dart';
import '../add_item_camera_page.dart';

class AddNewItemTile extends StatelessWidget {
  final Room roomSelected;

  const AddNewItemTile(this.roomSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AddItemCameraPage.routeName,
        arguments: {"intendedRoom": roomSelected},
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          color: (roomSelected == null)
              ? Theme.of(context).accentColor
              : roomSelected.color.material,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                (roomSelected == null)
                    ? "Add Item"
                    : "Add Item to\n" + roomSelected.name,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
