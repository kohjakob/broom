import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Image extends Equatable {
  final String filePath;

  Image({
    @required filePath,
  }) : this.filePath = filePath;

  @override
  List<Object> get props => [this.filePath];
}
