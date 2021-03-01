import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/room.dart';
import 'add_item_form_page.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';

class AddItemCameraPage extends StatefulWidget {
  static String routeName = "addItemCameraPage";

  @override
  _AddItemCameraPageState createState() => _AddItemCameraPageState();
}

class _AddItemCameraPageState extends State<AddItemCameraPage> {
  CameraController cameraController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final Room intendedRoom = arguments["intendedRoom"];
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
        actions: [
          SmallButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddItemFormPage.routeName,
                arguments: {"intendedRoom": intendedRoom},
              );
            },
            label: "Skip",
            color: Theme.of(context).accentColor,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Builder(
                  builder: (context) {
                    if (cameraController != null) {
                      return Column(
                        children: [
                          CameraLivePreview(cameraController),
                          CameraActions(intendedRoom, cameraController),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraActions extends StatelessWidget {
  final CameraController cameraController;
  final Room intendedRoom;

  const CameraActions(this.intendedRoom, this.cameraController);

  _takePicture(context) async {
    final xFile = await cameraController.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, xFile.name);
    // ignore: await_only_futures
    await xFile.saveTo(path);
    Navigator.of(context).pushNamed(
      AddItemFormPage.routeName,
      arguments: {
        "intendedRoom": intendedRoom,
        "imagePath": path,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Theme.of(context).accentColor.withAlpha(80),
              child: Material(
                color: Theme.of(context).accentColor,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: InkWell(
                    onTap: () => _takePicture(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraLivePreview extends StatelessWidget {
  final CameraController cameraController;

  CameraLivePreview(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRect(
        child: Transform.scale(
          scale: cameraController.value.aspectRatio,
          child: Center(
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );
  }
}
