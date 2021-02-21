import 'dart:io';

import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/camera_page.dart';
import 'package:broom/presentation/widgets/small_button.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormPage extends StatelessWidget {
  static String routeName = "formPage";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  _buildItemImage(context, state) {
    final imageProvide = (state is ImageSavedState)
        ? FileImage(File(state.filePath))
        : NetworkImage(
            "https://oldnavy.gap.com/webcontent/0018/569/346/cn18569346.jpg");
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(CameraPage.routeName),
      child: CircleAvatar(
        backgroundImage: imageProvide,
        radius: 70,
        backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopNavBar([
                    SmallButton(
                      () {
                        context.read<ItemsBloc>().add(AddItemEvent(
                            nameController.text, descriptionController.text));
                        Navigator.of(context).pop();
                      },
                      "Save",
                      Icons.add,
                      Theme.of(context).accentColor,
                    )
                  ]),
                  Form(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          _buildItemImage(context, state),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Title",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Icon(Icons.title),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText: "Description",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 54),
                                child: Icon(Icons.article_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
