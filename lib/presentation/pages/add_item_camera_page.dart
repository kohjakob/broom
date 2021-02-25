import 'package:broom/presentation/bloc/camera_cubit.dart';
import 'package:broom/presentation/pages/add_item_form_page.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddItemCameraPage extends StatelessWidget {
  static String routeName = "addItemCameraPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [
          SmallButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddItemFormPage.routeName);
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
                          CameraActions(),
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
  const CameraActions({
    Key key,
  }) : super(key: key);

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
                      Navigator.of(context)
                          .pushNamed(AddItemFormPage.routeName);
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