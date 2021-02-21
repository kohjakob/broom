import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/entities/item.dart';

class ItemModel extends Item {
  final int id;
  final String name;
  final String description;

  ItemModel({
    @required this.id,
    @required this.name,
    @required this.description,
  }) : super(
          id: id,
          name: name,
          description: description,
        );

  @override
  List<Object> get props => [id, name, description];
}
