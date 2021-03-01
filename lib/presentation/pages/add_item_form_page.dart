import 'dart:io';

import 'package:broom/presentation/bloc/item_detail_cubit.dart';

import '../../domain/entities/room.dart';
import '../bloc/grid_cubit.dart';
import 'grid_page_widgets/loading_fallback.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/colors.dart';

class AddItemFormPage extends StatelessWidget {
  static String routeName = "addItemFormPage";

  _buildItemImage(context, imagePath) {
    if (imagePath != null) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: CircleAvatar(
          backgroundImage: FileImage(File(imagePath)),
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
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        onBackPressed: () async {
          Navigator.of(context).pop();
        },
        actions: [
          BlocBuilder<ItemDetailCubit, ItemDetailState>(
              builder: (idContext, idState) {
            if (idState is ItemDetailLoaded) {
              return SmallButton(
                onPressed: () {
                  context.read<GridCubit>().addItem(
                        idState.item.name,
                        idState.item.description,
                        idState.item.imagePath,
                        idState.roomOfItem,
                      );
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                label: "Save Item",
                icon: Icons.add,
                color: Theme.of(context).accentColor,
              );
            } else {
              return Container();
            }
          }),
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
                      _buildItemImage(context, idState.item.imagePath),
                      SizedBox(height: 30),
                      TextFormField(
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
                        builder: (gridContext, gridState) {
                          if (gridState is GridLoaded) {
                            return DropdownButtonFormField(
                              value: (idState.roomOfItem == null)
                                  ? gridState.rooms.first
                                  : idState.roomOfItem,
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
                        },
                      )
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
