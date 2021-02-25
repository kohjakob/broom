import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'item.dart';

class Room extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<Item> items;

  Room({
    id,
    @required name,
    @required description,
    @required items,
  })  : this.id = id ?? null,
        this.name = name,
        this.description = description,
        this.items = items;

  @override
  List<Object> get props => [this.id, this.name, this.description, this.items];
}
