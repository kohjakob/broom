import 'dart:io';

import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/add_item_camera_page.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddItemFormPage extends StatelessWidget {
  static String routeName = "addItemFormPage";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  _buildItemImage(context, state) {
    if (state is ImageSavedState) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: CircleAvatar(
          backgroundImage: FileImage(File(state.filePath)),
          radius: 70,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: CircleAvatar(
          radius: 70,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
          child: Text(
            "📦",
            style: TextStyle(fontSize: 55),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        return Scaffold(
          appBar: TopNavBar(
            showBack: true,
            actions: [
              SmallButton(
                onPressed: () {
                  context.read<ItemsBloc>().add(
                        AddItemEvent(
                          nameController.text,
                          descriptionController.text,
                          (state is ImageSavedState) ? state.filePath : null,
                        ),
                      );
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                },
                label: "Save Item",
                icon: Icons.add,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          _buildItemImage(context, state),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Item Title",
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
