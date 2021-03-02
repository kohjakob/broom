import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'add_item_form_page.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditItemCameraPage extends StatefulWidget {
  static String routeName = "editItemCameraPage";

  @override
  _EditItemCameraPageState createState() => _EditItemCameraPageState();
}

class _EditItemCameraPageState extends State<EditItemCameraPage> {
  CameraController cameraController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
        actions: [],
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
                          CameraActions(cameraController),
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

  const CameraActions(this.cameraController);

  _takePicture(BuildContext context) async {
    final xFile = await cameraController.takePicture();
    await context.read<ItemDetailCubit>().setImage(xFile);
    Navigator.of(context).pop();
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
