import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/camera_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridPage extends StatelessWidget {
  static String routeName = "gridPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoaded) {
          return Column(
            children: [
              Container(
                child: Row(
                  children: [
                    FlatButton.icon(
                      color: Colors.red,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(CameraPage.routeName),
                      icon: Icon(Icons.add),
                      label: Text("Add new item"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: state.items.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(state.items[index].name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return FlatButton(
              child: Text("Add item"),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CameraPage.routeName));
        }
      },
    );
  }
}
