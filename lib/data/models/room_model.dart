import 'package:broom/core/constants/colors.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class RoomModel extends Room {
  final int id;
  final String name;
  final String description;
  final List<Item> items;
  final CustomColor color;

  RoomModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.items,
    @required this.color,
  }) : super(
          id: id,
          name: name,
          description: description,
          items: items,
          color: color,
        );

  @override
  List<Object> get props => [id, name, description, items, color];
}
