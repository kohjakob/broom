import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/room.dart';
import '../bloc/camera_cubit.dart';
import 'add_item_form_page.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';

class AddItemCameraPage extends StatelessWidget {
  static String routeName = "addItemCameraPage";

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final Room intendedRoom = arguments["intendedRoom"];
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
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
                child: BlocBuilder<CameraCubit, CameraState>(
                  builder: (context, state) {
                    if (state.camera.cameraController != null) {
                      return Column(
                        children: [
                          CameraLivePreview(state),
                          CameraActions(intendedRoom),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Seems like your device doesn't have a camera",
                        ),
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
  final Room intendedRoom;
  const CameraActions(this.intendedRoom);

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
                    onTap: () {
                      context.read<CameraCubit>().takePicture();
                      Navigator.of(context).pushNamed(
                        AddItemFormPage.routeName,
                        arguments: {"intendedRoom": intendedRoom},
                      );
                    },
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
  final CameraState state;

  CameraLivePreview(this.state);

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      state.camera.cameraController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRect(
        child: Transform.scale(
          scale: state.camera.cameraController.value.aspectRatio,
          child: Center(
            child: CameraPreview(state.camera.cameraController),
          ),
        ),
      ),
    );
  }
}
