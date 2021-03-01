import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../domain/entities/room.dart';
import '../add_item_camera_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewItemTile extends StatelessWidget {
  final Room roomSelected;
  const AddNewItemTile(this.roomSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ItemDetailCubit>().setEmptyItem(roomSelected);
        Navigator.of(context).pushNamed(AddItemCameraPage.routeName);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(0),
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
              SizedBox(height: 5),
              FittedBox(
                child: Text(
                  "Add item",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
