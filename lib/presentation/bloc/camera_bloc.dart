import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:broom/device/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  Camera camera;

  CameraBloc(this.camera) : super(CameraInitial(camera));

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is SnapImageEvent) {
      final path = await camera.snapImage();
      yield ImageSavedState(camera, path);
    }
  }
}
