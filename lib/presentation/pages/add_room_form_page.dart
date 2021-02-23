import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';

class AddRoomFormPage extends StatelessWidget {
  static String routeName = "addRoomFormPage";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [
          SmallButton(
            onPressed: () => null,
            label: "Save Room",
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
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Room Title",
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
  }
}
