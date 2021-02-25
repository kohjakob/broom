import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class RoomModel extends Room {
  final int id;
  final String name;
  final String description;
  final List<Item> items;

  RoomModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.items,
  }) : super(
          id: id,
          name: name,
          description: description,
          items: items,
        );

  @override
  List<Object> get props => [id, name, description, items];
}
