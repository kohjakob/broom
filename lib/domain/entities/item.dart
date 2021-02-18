import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final String name;
  final String description;

  Item({
    @required this.name,
    @required this.description,
  }) : super([name, description]);
}
