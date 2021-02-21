part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  final Camera camera;
  const CameraState(this.camera);

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {
  CameraInitial(Camera camera) : super(camera);
}

class ImageSavedState extends CameraState {
  final filePath;

  ImageSavedState(Camera camera, this.filePath) : super(camera);

  @override
  List<Object> get props => [filePath];
}
