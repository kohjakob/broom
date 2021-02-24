import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/entities/item.dart';

class ItemModel extends Item {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final int roomId;

  ItemModel({
    @required this.id,
    @required this.imagePath,
    @required this.name,
    @required this.description,
    @required this.roomId,
  }) : super(
          id: id,
          name: name,
          description: description,
          imagePath: imagePath,
          roomId: roomId,
        );

  @override
  List<Object> get props => [id, name, description, imagePath];
}
