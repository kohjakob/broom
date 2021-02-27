import 'package:equatable/equatable.dart';

enum Code {
  InsufficientItemInfo,
  ItemSaveFail,
  NoItemsYet,
  RoomSaveFail,
  NoRoomsYet,
  RoomEditFail,
  ItemEditFail,
}

class Failure extends Equatable {
  final Code code;

  Failure(this.code);

  @override
  List<Object> get props => [code];
}
