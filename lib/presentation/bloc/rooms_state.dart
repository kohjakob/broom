part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsNotLoaded extends RoomsState {}

abstract class RoomsLoaded extends RoomsState {
  final List<Room> rooms;
  final int selectedIndex;

  RoomsLoaded(this.rooms, this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class NoRoomSelected extends RoomsLoaded {
  NoRoomSelected(rooms) : super(rooms, null);

  @override
  List<Object> get props => [...rooms];
}

class RoomSelected extends RoomsLoaded {
  RoomSelected(rooms, selectedIndex) : super(rooms, selectedIndex);

  @override
  List<Object> get props => [...rooms, selectedIndex];
}
