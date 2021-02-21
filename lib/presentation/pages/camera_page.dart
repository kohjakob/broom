import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/pages/form_page.dart';
import 'package:broom/presentation/widgets/small_button.dart';
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
            TopNavBar([
              SmallButton(
                () {
                  Navigator.of(context).pushNamed(FormPage.routeName);
                },
                "Skip",
                Icons.arrow_forward,
                Theme.of(context).accentColor.withAlpha(100),
              )
            ]),
            Expanded(
              child: BlocBuilder<CameraBloc, CameraState>(
                builder: (context, state) {
                  if (state.camera.cameraController != null) {
                    return Container(
                      child: Stack(
                        children: [
                          Container(
                            child: state.camera.cameraController.buildPreview(),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.white.withAlpha(200),
                              padding: EdgeInsets.all(30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CameraBloc>()
                                          .add(SnapImageEvent());
                                      Navigator.of(context)
                                          .pushNamed(FormPage.routeName);
                                    },
                                    child: CircleAvatar(
                                      radius: 34,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text("Seems like your phone does not have a camera");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
