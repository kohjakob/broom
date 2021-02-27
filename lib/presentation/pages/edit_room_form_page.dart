import '../../core/constants/colors.dart';
import '../../domain/entities/room.dart';
import '../bloc/grid_cubit.dart';
import 'widgets/small_button.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRoomFormPage extends StatefulWidget {
  static String routeName = "editRoomFormPage";

  @override
  _EditRoomFormPageState createState() => _EditRoomFormPageState();
}

class _EditRoomFormPageState extends State<EditRoomFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  CustomColor color;
  bool isInit = false;

  @override
  initState() {
    super.initState();
    color = CustomColor.ORANGE;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final Room roomToEdit = arguments["roomToEdit"];
    nameController.value = TextEditingValue(text: roomToEdit.name);
    descriptionController.value =
        TextEditingValue(text: roomToEdit.description);

    if (!isInit) {
      setState(() {
        isInit = true;
        color = roomToEdit.color;
      });
    }

    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [
          SmallButton(
            onPressed: () {
              context.read<GridCubit>().editRoom(
                    roomToEdit.id,
                    nameController.text,
                    descriptionController.text,
                    color,
                  );
              Navigator.of(context).pop();
            },
            label: "Update Room",
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
                  value: roomToEdit.color,
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
