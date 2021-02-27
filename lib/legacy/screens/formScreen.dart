import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';

class AddForm extends StatefulWidget {
  static const routeName = "/add-form";
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _saveItem(String imgPath) {
    var title = titleController.value.text == ""
        ? "Untitled"
        : titleController.value.text;
    var description = descriptionController.value.text == ""
        ? "No description"
        : descriptionController.value.text;
    Provider.of<Items>(context).addItem(title, description, imgPath);
    Provider.of<Items>(context, listen: false).fetchAndSetItems();
    Navigator.of(context).popUntil((route) => (route.settings.name == "/"));
  }

  @override
  Widget build(context) {
    final String imgPath = ModalRoute.of(context).settings.arguments as String;
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
                      decoration: InputDecoration(labelText: "Title"),
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
                          child: Text("Back"),
                        ),
                        OutlineButton(
                          onPressed: () => _saveItem(imgPath),
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
