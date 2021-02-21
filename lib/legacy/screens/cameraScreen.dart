import 'dart:async';

import 'package:broom/legacy/screens/formScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../assets/constants.dart' as Constants;

class AddCamera extends StatefulWidget {
  static const routeName = "/add-camera";
  final CameraDescription camera;
  AddCamera(this.camera);

  @override
  _AddCameraState createState() => _AddCameraState();
}

class _AddCameraState extends State<AddCamera> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = "${DateTime.now()}.png";
      final path = join(appDir.path, fileName);
      final pathTo = await _cameraController.takePicture();
      Navigator.of(context)
          .pushNamed(AddForm.routeName, arguments: pathTo.path);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        iconTheme: IconThemeData(color: Colors.indigo.shade500),
        title: Text(
          "Take a picture",
          style: TextStyle(color: Colors.indigo.shade500),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.8,
                child: Container(
                  margin: EdgeInsets.fromLTRB(Constants.defaultPadding,
                      Constants.defaultPadding, Constants.defaultPadding, 0),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.indigo.shade100),
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.defaultBorderRadius)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.defaultBorderRadius)),
                    child: FutureBuilder<void>(
                      future: _initializeCameraControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_cameraController);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonBar(
                      children: [
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Dismiss"),
                        ),
                        OutlineButton(
                          onPressed: () => _takePicture(context),
                          child: Text("Take picture"),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
