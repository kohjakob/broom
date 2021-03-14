import 'dart:io';

import 'package:broom/domain/entities/question.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/pages/edit_item_form_page.dart';
import 'package:broom/presentation/pages/grid_page_widgets/loading_fallback.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';
import '../widgets/top_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailPage extends StatefulWidget {
  static String routeName = "itemDetailPage";

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  _editItem(Item itemToEdit, int roomId, BuildContext context) async {
    final updatedItem =
        await Navigator.of(context).pushNamed(EditItemFormPage.routeName);
    if (updatedItem != null) {
      context.read<ItemDetailCubit>().setItem(updatedItem, roomId);
    }
  }

  _deleteItem(Item item) {
    final deleteDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(10, 20, 30, 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      title: Text("Really delete " + item.name + "?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            context.read<GridCubit>().deleteItem(item.id);
            Navigator.of(context).popUntil(ModalRoute.withName("/"));
          },
          child: Text("Yes"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => deleteDialog,
    );
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
                                        idState.item.roomId,
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
                            SizedBox(height: 20),
                            ...idState.questionAnswers.entries.map(
                              (entry) {
                                return QuestionAnswerTile(entry);
                              },
                            ).toList(),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return LoadingFallback();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionAnswerTile extends StatelessWidget {
  final entry;
  const QuestionAnswerTile(this.entry);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.indigoAccent,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.key.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.thumb_up,
                size: (entry.value == Answer.Yes) ? 20 : 18,
                color:
                    (entry.value == Answer.Yes) ? Colors.white : Colors.indigo,
              ),
              SizedBox(width: 15),
              Icon(
                Icons.thumb_down,
                size: (entry.value == Answer.No) ? 20 : 18,
                color:
                    (entry.value == Answer.No) ? Colors.white : Colors.indigo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
