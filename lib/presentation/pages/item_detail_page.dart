import 'dart:io';

import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/pages/edit_item_form_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';
import 'widgets/top_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailPage extends StatefulWidget {
  static String routeName = "itemDetailPage";

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  _editItem(Item itemToEdit, Room room, BuildContext context) async {
    final updatedItem =
        await Navigator.of(context).pushNamed(EditItemFormPage.routeName);
    if (updatedItem != null) {
      context.read<ItemDetailCubit>().setItem(updatedItem, room);
    }
  }

  _deleteItem(Item item) {
    final deleteDialog = AlertDialog(
      title: Text("Really delete " + item.name + "?"),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        FlatButton(
          onPressed: () {
            context.read<GridCubit>().deleteItem(item.id);
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          },
          child: Text("Yes"),
        ),
      ],
    );
    showDialog(context: context, child: deleteDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        onBackPressed: () {
          Navigator.of(context).pop();
        },
        showBack: true,
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: BlocBuilder<ItemDetailCubit, ItemDetailState>(
              builder: (idContext, idState) {
                if (idState is ItemDetailLoaded) {
                  return Column(
                    children: [
                      (idState.item.imagePath != null)
                          ? Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(idState.item.imagePath),
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
                                Expanded(
                                  child: Text(
                                    idState.item.name,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => _editItem(
                                        idState.item,
                                        idState.roomOfItem,
                                        context,
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () =>
                                            _deleteItem(idState.item))
                                  ],
                                )
                              ],
                            ),
                            Text(
                              idState.item.description,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
