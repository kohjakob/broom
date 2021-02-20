import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(builder: (context, state) {
      return FlatButton(
        child: Text("Add item"),
        onPressed: () => context.read<ItemsBloc>().add(
              AddItemEvent("Test", "Description"),
            ),
      );
    });
  }
}
