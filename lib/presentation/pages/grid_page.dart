import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/camera_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                color: Theme.of(context).accentColor.withAlpha(20),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Search items or rooms",
                            prefixIcon: Icon(Icons.search),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: DropdownButton(
                          underline: Container(),
                          items: [
                            DropdownMenuItem(
                              child: FaIcon(FontAwesomeIcons.sortAlphaDown),
                            ),
                            DropdownMenuItem(
                              child: FaIcon(FontAwesomeIcons.sortAlphaUp),
                            ),
                            DropdownMenuItem(
                              child: FaIcon(FontAwesomeIcons.calendarAlt),
                            ),
                          ],
                          onChanged: (value) => null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ItemGrid(state),
            ],
          );
        } else {
          return NoItemsFallback();
        }
      },
    );
  }
}

class NoItemsFallback extends StatelessWidget {
  const NoItemsFallback();

  @override
  Widget build(BuildContext context) {
    return AddNewItemTile();
  }
}

class ItemGrid extends StatelessWidget {
  final ItemsLoaded state;
  ItemGrid(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: state.items.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          if (index == 0) {
            return AddNewItemTile();
          } else {
            return ItemTile(state, index);
          }
        },
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final int index;
  final ItemsLoaded state;
  ItemTile(this.state, this.index);

  @override
  Widget build(BuildContext context) {
    Item item = state.items[index - 1];

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              item.imagePath != null
                  ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(30),
                          image: DecorationImage(
                            image: FileImage(
                              File(item.imagePath),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.all(15),
                color: Colors.indigo.shade50,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
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

class AddNewItemTile extends StatelessWidget {
  const AddNewItemTile();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(CameraPage.routeName),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Theme.of(context).accentColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                "Add new item",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
