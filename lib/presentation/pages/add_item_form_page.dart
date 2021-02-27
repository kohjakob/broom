import 'dart:io';

import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/camera_cubit.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:broom/core/constants/colors.dart';

class AddItemFormPage extends StatefulWidget {
  static String routeName = "addItemFormPage";

  @override
  _AddItemFormPageState createState() => _AddItemFormPageState();
}

class _AddItemFormPageState extends State<AddItemFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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
    if (!isInit) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      final Room intendedRoom = arguments["intendedRoom"];
      setState(() {
        isInit = true;
        selectedRoom = intendedRoom;
      });
    }

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Scaffold(
          appBar: TopNavBar(
            showBack: true,
            actions: [
              SmallButton(
                onPressed: () {
                  context.read<GridCubit>().addItem(
                        nameController.text,
                        descriptionController.text,
                        (state is ImageSavedState) ? state.filePath : null,
                        selectedRoom,
                      );
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                label: "Save Item",
                icon: Icons.add,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          _buildItemImage(context, state),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Item Title",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Icon(Icons.title),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText: "Description",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 54),
                                child: Icon(Icons.article_outlined),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          BlocBuilder<GridCubit, GridState>(
                              builder: (ctx, state) {
                            if (state is GridLoaded) {
                              return DropdownButtonFormField(
                                value: (selectedRoom == null)
                                    ? state.rooms.first
                                    : selectedRoom,
                                items: [
                                  ...state.rooms
                                      .map(
                                        (room) => DropdownMenuItem<Room>(
                                          value: room,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      room.color.material),
                                              SizedBox(width: 10),
                                              Text(room.name),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                                onChanged: (room) {
                                  setState(() {
                                    selectedRoom = room;
                                  });
                                },
                              );
                            } else {
                              return Container();
                            }
                          })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
