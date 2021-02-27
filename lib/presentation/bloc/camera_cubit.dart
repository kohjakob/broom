import 'package:bloc/bloc.dart';
import '../../device/camera.dart';
import 'package:equatable/equatable.dart';

class CameraCubit extends Cubit<CameraState> {
  final Camera camera;

  CameraCubit(this.camera) : super(CameraInitial(camera)) {
    camera.initCamera();
  }

  takePicture() async {
    final path = await camera.snapImage();
    emit(ImageSavedState(camera, path));
  }
}

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
