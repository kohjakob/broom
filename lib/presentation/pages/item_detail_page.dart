import 'dart:io';

import 'package:broom/presentation/pages/edit_item_form_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';
import 'widgets/top_nav_bar.dart';

class ItemDetailPage extends StatelessWidget {
  static String routeName = "itemDetailPage";

  _editItem(Item item, context) {
    Navigator.of(context)
        .pushNamed(EditItemFormPage.routeName, arguments: {"item": item});
  }

  _deleteItem(Item item, context) {
    final deleteDialog = AlertDialog(
      title: Text("Really delete " + item.name + "?"),
      actions: [
        FlatButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("No")),
        FlatButton(onPressed: null, child: Text("Yes")),
      ],
    );
    showDialog(context: context, child: deleteDialog);
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final Item item = arguments["item"];
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                (item.imagePath != null)
                    ? Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(item.imagePath),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editItem(item, context)),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteItem(item, context))
                            ],
                          )
                        ],
                      ),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
