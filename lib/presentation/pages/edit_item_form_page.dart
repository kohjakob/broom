import 'dart:io';

import 'package:broom/domain/entities/item.dart';

import '../bloc/camera_cubit.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditItemFormPage extends StatefulWidget {
  static String routeName = "editItemFormPage";

  @override
  _EditItemFormPageState createState() => _EditItemFormPageState();
}

class _EditItemFormPageState extends State<EditItemFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Item item;
  var selectedRoom;
  bool isInit = false;

  _buildItemImage(context, state) {
    if (state is ImageSavedState) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: CircleAvatar(
          backgroundImage: FileImage(File(state.filePath)),
          radius: 70,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: CircleAvatar(
          radius: 70,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
          child: Text(
            "📦",
            style: TextStyle(fontSize: 55),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Scaffold(
          appBar: TopNavBar(
            showBack: true,
            actions: [
              SmallButton(
                onPressed: () => null,
                label: "Update Item",
                icon: Icons.add,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
