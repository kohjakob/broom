import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final int id;
  final String name;
  final String description;

  Item({
    id,
    @required name,
    @required description,
  })  : this.id = id ?? null,
        this.name = _checkSufficiency(name),
        this.description = _checkSufficiency(description);

  static _checkSufficiency(String string) {
    if (string == "") {
      throw InsufficientItemInfoException();
    } else {
      return string;
    }
  }

  @override
  List<Object> get props => [this.id, this.name, this.description];
}
