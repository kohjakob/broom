import 'dart:io';
import 'package:flutter/material.dart';
import '../assets/constants.dart' as Constants;
import 'package:provider/provider.dart';
import '../providers/items.dart';
import '../providers/item.dart';

class EditForm extends StatefulWidget {
  static const routeName = "/edit-form";
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _updateItem(id, imgPath) {
    var title = titleController.value.text == "" ? "Untitled" : titleController.value.text;
    var description = descriptionController.value.text == "" ? "No description" : descriptionController.value.text;
    Provider.of<Items>(context).updateItem(id, title, description, imgPath);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var item = ModalRoute.of(context).settings.arguments as Item;
    descriptionController.text = item.description == "No description" ? "" : item.description;
    titleController.text = item.title == "Untitled" ? "" : item.title;
    var id = item.id;
    var imgPath = item.imgUrl;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        iconTheme: IconThemeData(color: Colors.indigo.shade500),
        title: Text(
          "Add infos",
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
                width: constraints.maxWidth * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      controller: titleController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Description"),
                      controller: descriptionController,
                    ),
                  ],
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
                          onPressed: () => _updateItem(id, imgPath),
                          child: Text("Save"),
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
