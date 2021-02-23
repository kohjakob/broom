part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class GetRoomsEvent extends RoomsEvent {}

class AddRoomEvent extends RoomsEvent {
  final String name;
  final String description;
  final String color;

  AddRoomEvent(this.name, this.description, this.color) : super();

  @override
  List<Object> get props => [name, description, color];
}
