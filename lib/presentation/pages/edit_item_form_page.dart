import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/pages/edit_item_camera_page.dart';
import 'package:broom/presentation/pages/grid_page_widgets/loading_fallback.dart';

import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:broom/core/constants/colors.dart';

class EditItemFormPage extends StatelessWidget {
  static String routeName = "editItemFormPage";

  _editItem(state, BuildContext context) {
    context.read<GridCubit>().editItem(
          state.item.id,
          state.item.name,
          state.item.description,
          state.roomOfItem,
          state.item.imagePath,
        );
    final editedItem = Item(
      id: state.item.id,
      name: state.item.name,
      description: state.item.description,
      roomId: state.item.roomId,
      imagePath: state.item.imagePath,
    );
    Navigator.of(context).pop(editedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
        actions: [
          BlocBuilder<ItemDetailCubit, ItemDetailState>(
            builder: (idContext, idState) {
              if (idState is ItemDetailLoaded) {
                return SmallButton(
                  onPressed: () => _editItem(idState, idContext),
                  label: "Update Item",
                  icon: Icons.add,
                  color: Theme.of(context).accentColor,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: BlocBuilder<ItemDetailCubit, ItemDetailState>(
              builder: (idContext, idState) {
                if (idState is ItemDetailLoaded) {
                  return Column(
                    children: [
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(EditItemCameraPage.routeName);
                        },
                        child: Stack(
                          children: [
                            (idState.item.imagePath != null)
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(idState.item.imagePath)),
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
                        initialValue: idState.item.name,
                        onChanged: (newName) =>
                            context.read<ItemDetailCubit>().setName(newName),
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
                        initialValue: idState.item.description,
                        onChanged: (newDescription) => context
                            .read<ItemDetailCubit>()
                            .setDescription(newDescription),
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
                          builder: (ctx, gridState) {
                        if (gridState is GridLoaded) {
                          return DropdownButtonFormField(
                            value: idState.roomOfItem,
                            items: [
                              ...gridState.rooms
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
                              context.read<ItemDetailCubit>().setRoom(room);
                            },
                          );
                        } else {
                          return Container();
                        }
                      })
                    ],
                  );
                } else {
                  return LoadingFallback();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
