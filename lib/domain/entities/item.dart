import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final String _id;
  final String _name;
  final String _description;

  Item({
    String id,
    @required String name,
    @required String description,
  })  : _id = id ?? null,
        _name = _checkSufficiency(name),
        _description = _checkSufficiency(description);

  static _checkSufficiency(String string) {
    if (string.isEmpty) {
      throw InsufficientItemInfoException();
    } else {
      return string;
    }
  }

  @override
  List<Object> get props => [_id, _name, _description];
}
