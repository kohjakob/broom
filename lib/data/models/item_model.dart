import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/entities/item.dart';

@HiveType(typeId: 1)
class ItemModel extends Item {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;

  ItemModel({
    @required this.id,
    @required this.name,
    @required this.description,
  }) : super(id: id, name: name, description: description);

  @override
  List<Object> get props => [id, name, description];
}
