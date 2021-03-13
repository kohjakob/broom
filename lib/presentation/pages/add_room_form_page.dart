import 'package:broom/presentation/bloc/room_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/colors.dart';
import '../bloc/grid_cubit.dart';
import 'grid_page_widgets/loading_fallback.dart';
import '../widgets/small_button.dart';
import '../widgets/top_nav_bar.dart';

class AddRoomFormPage extends StatelessWidget {
  static String routeName = "addRoomFormPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
        actions: [
          BlocBuilder<RoomDetailCubit, RoomDetailState>(
            builder: (rdContext, rdState) {
              if (rdState is RoomDetailLoaded) {
                return SmallButton(
                  onPressed: () {
                    context.read<GridCubit>().addRoom(
                          rdState.room.name,
                          rdState.room.description,
                          rdState.room.color,
                        );
                    Navigator.of(context).pop();
                  },
                  label: "Save Room",
                  icon: Icons.add,
                  color: Theme.of(context).accentColor,
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: BlocBuilder<RoomDetailCubit, RoomDetailState>(
              builder: (rdContext, rdState) {
                if (rdState is RoomDetailLoaded) {
                  return Column(
                    children: [
                      TextFormField(
                        onChanged: (newName) =>
                            context.read<RoomDetailCubit>().setName(newName),
                        decoration: InputDecoration(
                          hintText: "Room Title",
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Icon(Icons.title),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onChanged: (newDescription) => context
                            .read<RoomDetailCubit>()
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
                      DropdownButtonFormField(
                        value: rdState.room.color,
                        items: CustomColor.values
                            .map(
                              (color) => DropdownMenuItem<CustomColor>(
                                value: color,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundColor: color.material),
                                    SizedBox(width: 10),
                                    Text(color.name),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (newColor) =>
                            context.read<RoomDetailCubit>().setColor(newColor),
                      ),
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
