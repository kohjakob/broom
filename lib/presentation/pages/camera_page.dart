import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/pages/form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatelessWidget {
  static String routeName = "cameraPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            if (state.camera.cameraController != null) {
              return Column(
                children: [
                  Expanded(
                    child: state.camera.cameraController.buildPreview(),
                  ),
                  FlatButton(
                    onPressed: () {
                      context.read<CameraBloc>().add(SnapImageEvent());
                      Navigator.of(context).pushNamed(FormPage.routeName);
                    },
                    child: Text("Snap picture"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(FormPage.routeName);
                    },
                    child: Text("No image"),
                  )
                ],
              );
            } else {
              return Text("Seems like your phone does not have a camera");
            }
          },
        ),
      ),
    );
  }
}
