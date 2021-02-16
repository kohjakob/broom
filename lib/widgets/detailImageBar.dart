import 'package:flutter/material.dart';
import 'package:ownless2/screens/editScreen.dart';
import 'dart:io';
import '../providers/item.dart';
import 'package:provider/provider.dart';
import '../providers/items.dart';

class ImageBar extends StatelessWidget {
  const ImageBar(this.item);
  final Item item;

  _deleteItem(Item item, context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Do you really want to delete this item?"),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<Items>(context, listen: false).deleteItem(item.id);
              Navigator.of(context).popUntil((route) => (route.settings.name == "/"));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(
        item.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.indigo.shade500,
        ),
      ),
      toolbarHeight: 55,
      centerTitle: true,
      expandedHeight: 380,
      stretch: true,
      elevation: 0,
      backgroundColor: Colors.indigo.shade100,
      iconTheme: IconThemeData(color: Colors.indigo.shade500),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () => _deleteItem(item, context),
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.indigo.shade500,
          ),
          onPressed: () => Navigator.of(context).pushNamed(EditForm.routeName, arguments: item),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          margin: EdgeInsets.only(top: 55),
          child: Image.file(
            File(item.imgUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
