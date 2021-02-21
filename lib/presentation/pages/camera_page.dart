import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/form_page.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatelessWidget {
  static String routeName = "cameraPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopNavBar(
              showBack: true,
              actions: [
                SmallButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FormPage.routeName);
                  },
                  label: "Skip",
                  color: Theme.of(context).accentColor.withAlpha(100),
                )
              ],
            ),
            Expanded(
              child: Container(
                child: BlocBuilder<CameraBloc, CameraState>(
                  builder: (context, state) {
                    if (state.camera.cameraController != null) {
                      return Stack(
                        children: [
                          CameraPreview(state),
                          CameraActions(),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Seems like your device doesn't have a camera",
                        ),
                      );
                      ;
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.indigo.shade50,
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: Material(
                color: Theme.of(context).accentColor,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.read<CameraBloc>().add(SnapImageEvent());
                      Navigator.of(context).pushNamed(FormPage.routeName);
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

class CameraPreview extends StatelessWidget {
  CameraState state;

  CameraPreview(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: state.camera.cameraController.buildPreview(),
    );
  }
}
