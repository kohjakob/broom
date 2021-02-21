import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Camera {
  CameraController cameraController;
  Camera._create();

  static Future<Camera> create() async {
    final camera = Camera._create();
    await camera.initCamera();
    return camera;
  }

  initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      await cameraController.initialize();
    }
  }

  Future<String> snapImage() async {
    final xFile = await cameraController.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, xFile.name);
    // ignore: await_only_futures
    await xFile.saveTo(path);
    return path;
  }
}
