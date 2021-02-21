import 'package:broom/domain/entities/image.dart';
import 'package:meta/meta.dart';

class ImageModel extends Image {
  final String filePath;

  ImageModel({
    @required filePath,
  }) : this.filePath = filePath;

  @override
  List<Object> get props => [this.filePath];
}
