import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/grid_cubit.dart' as cubit;
import 'add_new_room_button.dart';
import 'room_button.dart';

class RoomBar extends StatelessWidget {
  final cubit.GridState state;

  const RoomBar(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(0),
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: 65,
      child: Builder(
        builder: (ctx) {
          if (state is cubit.GridLoaded) {
            final loadedState = state as cubit.GridLoaded;
            return ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 20),
                AddNewRoomButton(),
                RoomButton(
                  selected: (loadedState.roomSelected == null),
                  room: null,
                  count: loadedState.displayItems.length,
                  onPressed: () =>
                      context.read<cubit.GridCubit>().filterItems(null),
                ),
                ...loadedState.rooms.map(
                  (room) {
                    if (room.id != -1) {
                      return RoomButton(
                        selected: (loadedState.roomSelected == room),
                        room: room,
                        count: room.items.length,
                        onPressed: () =>
                            context.read<cubit.GridCubit>().filterItems(room),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(width: 20),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class GridCubit {}
