import 'dart:io';

import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormPage extends StatelessWidget {
  static String routeName = "formPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is ImageSavedState) {
          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Image.file(File(state.filePath)),
                  ),
                  FlatButton(
                    onPressed: () => context
                        .read<ItemsBloc>()
                        .add(AddItemEvent("Test", "Item")),
                    child: Text("Save item"),
                  )
                ],
              ),
            ),
          );
        } else {
          return Text("Loading...");
        }
      },
    );
  }
}
