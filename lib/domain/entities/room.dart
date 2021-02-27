import '../../core/constants/colors.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'item.dart';

class Room extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<Item> items;
  final CustomColor color;

  Room({
    id,
    @required name,
    @required description,
    @required items,
    @required color,
  })  : this.id = id ?? null,
        this.name = name,
        this.description = description,
        this.items = items,
        this.color = color;

  bool operator ==(dynamic other) =>
      other != null && other is Room && this.id == other.id;

  @override
  int get hashCode => super.hashCode;

  @override
  List<Object> get props =>
      [this.id, this.name, this.description, this.items, this.color];
}
