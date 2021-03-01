import 'package:bloc/bloc.dart';
import 'package:broom/core/constants/colors.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/room.dart';

class RoomDetailCubit extends Cubit<RoomDetailState> {
  RoomDetailCubit() : super(RoomDetailLoading());

  setRoom(Room room) async {
    emit(RoomDetailLoaded(room));
  }

  setEmptyRoom() async {
    emit(
      RoomDetailLoaded(
        Room(
          name: "",
          description: "",
          color: CustomColor.MIDNIGHT,
          items: List<Item>.empty(),
        ),
      ),
    );
  }

  setName(String name) {
    if (state is RoomDetailLoaded) {
      final previous = state as RoomDetailLoaded;
      final newRoom = Room(
        name: name,
        description: previous.room.description,
        color: previous.room.color,
        items: previous.room.items,
        id: previous.room.id,
      );
      emit(RoomDetailLoaded(newRoom));
    }
  }

  setDescription(String description) {
    if (state is RoomDetailLoaded) {
      final previous = state as RoomDetailLoaded;
      final newRoom = Room(
        name: previous.room.name,
        description: description,
        color: previous.room.color,
        items: previous.room.items,
        id: previous.room.id,
      );
      emit(RoomDetailLoaded(newRoom));
    }
  }

  setColor(CustomColor color) {
    if (state is RoomDetailLoaded) {
      final previous = state as RoomDetailLoaded;
      final newRoom = Room(
        name: previous.room.name,
        description: previous.room.description,
        color: color,
        items: previous.room.items,
        id: previous.room.id,
      );
      emit(RoomDetailLoaded(newRoom));
    }
  }
}

abstract class RoomDetailState extends Equatable {
  const RoomDetailState();

  @override
  List<Object> get props => [];
}

class RoomDetailLoading extends RoomDetailState {}

class RoomDetailLoaded extends RoomDetailState {
  final Room room;

  RoomDetailLoaded(this.room);

  @override
  List<Object> get props => [room.color, room.description, room.name];
}
