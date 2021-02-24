import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/domain/usecases/add_room.dart';
import 'package:broom/domain/usecases/get_rooms.dart';
import 'package:equatable/equatable.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final GetRooms getRooms;
  final AddRoom addRoom;

  RoomsBloc(this.getRooms, this.addRoom) : super(RoomsNotLoaded()) {
    this.add(GetRoomsEvent());
  }

  @override
  Stream<RoomsState> mapEventToState(
    RoomsEvent event,
  ) async* {
    if (event is GetRoomsEvent) {
      yield await _getRoomsEvent(event, state);
    }
    if (event is AddRoomEvent) {
      yield await _addRoomEvent(event, state);
    }
  }

  Future<RoomsState> _getRoomsEvent(event, state) async {
    var either;
    either = await getRooms.execute();

    return await either.fold(
      (failure) {
        return RoomsNotLoaded();
      },
      (rooms) {
        if (state is RoomSelected) {
          return RoomSelected(rooms, state.selectedIndex);
        } else {
          return NoRoomSelected(rooms);
        }
      },
    );
  }

  Future<RoomsState> _addRoomEvent(event, state) async {
    var either;
    either = await addRoom.execute(
      name: event.name,
      description: event.description,
      color: event.color,
    );

    return await either.fold((failure) async {
      return RoomsNotLoaded();
    }, (item) async {
      add(GetRoomsEvent());
    });
  }
}
