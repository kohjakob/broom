import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';

import '../bloc/camera_cubit.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:broom/core/constants/colors.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    item = arguments["item"];
    final state = context.read<GridCubit>().state as GridLoaded;
    selectedRoom = state.rooms.where((room) => room.id == item.roomId).first;
    nameController.text = item.name;
    descriptionController.text = item.description;
  }

  _editItem() {
    context.read<GridCubit>().editItem(
        item.id, nameController.text, descriptionController.text, selectedRoom);
    final editedItem = Item(
      id: item.id,
      name: nameController.text,
      description: descriptionController.text,
      roomId: selectedRoom.id,
    );
    Navigator.of(context).pop(editedItem);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (cameraContext, state) {
        return Scaffold(
          appBar: TopNavBar(
            showBack: true,
            actions: [
              SmallButton(
                onPressed: () => _editItem(),
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
                  children: [
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Stack(
                        children: [
                          (item.imagePath != null)
                              ? CircleAvatar(
                                  backgroundImage:
                                      FileImage(File(item.imagePath)),
                                  radius: 70,
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(50),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).accentColor.withAlpha(170),
                            radius: 70,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    BlocBuilder<GridCubit, GridState>(builder: (ctx, state) {
                      if (state is GridLoaded) {
                        return DropdownButtonFormField(
                          value: selectedRoom,
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
            ),
          ),
        );
      },
    );
  }
}
