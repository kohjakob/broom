import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/colors.dart';
import '../bloc/grid_cubit.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';

class AddRoomFormPage extends StatefulWidget {
  static String routeName = "addRoomFormPage";

  @override
  _AddRoomFormPageState createState() => _AddRoomFormPageState();
}

class _AddRoomFormPageState extends State<AddRoomFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  CustomColor color;

  @override
  initState() {
    super.initState();
    color = CustomColor.MIDNIGHT;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [
          SmallButton(
            onPressed: () {
              context.read<GridCubit>().addRoom(
                    nameController.text,
                    descriptionController.text,
                    color,
                  );
              Navigator.of(context).pop();
            },
            label: "Save Room",
            icon: Icons.add,
            color: Theme.of(context).accentColor,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                DropdownButtonFormField(
                  value: color,
                  items: CustomColor.values
                      .map(
                        (color) => DropdownMenuItem<CustomColor>(
                          value: color,
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 15, backgroundColor: color.material),
                              SizedBox(width: 10),
                              Text(color.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newColor) {
                    setState(() {
                      color = newColor;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
