import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/add_item_camera_page.dart';
import 'package:broom/presentation/pages/add_room_form_page.dart';
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
                    SearchBar(),
                    SizedBox(width: 20),
                    SortDropdown(),
                  ],
                ),
              ),
              RoomBar(),
              ItemGrid(state),
            ],
          );
        } else if (state is ItemsLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return NoItemsFallback();
        }
      },
    );
  }
}

class RoomBar extends StatelessWidget {
  const RoomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: 65,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 20),
          AddNewRoomButton(),
          RoomButton(
            color: Theme.of(context).primaryColor,
            label: "All",
            count: 112,
            onPressed: () => null,
          ),
          RoomButton(
            color: Colors.red.shade300,
            label: "🍳",
            count: 1,
            onPressed: () => null,
          ),
          RoomButton(
            color: Colors.orange.shade300,
            label: "👨‍💻",
            count: 1,
            onPressed: () => null,
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class RoomButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color color;
  final int count;

  RoomButton({
    this.onPressed,
    this.label,
    this.color = Colors.indigoAccent,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 10, 1),
      child: ButtonTheme(
        minWidth: 10,
        child: OutlineButton(
          highlightedBorderColor: color,
          highlightColor: color.withAlpha(50),
          splashColor: color.withAlpha(50),
          shape: StadiumBorder(),
          onPressed: onPressed,
          borderSide: BorderSide(color: color, width: 1),
          padding: EdgeInsets.fromLTRB(14, 10, 12, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(color: color),
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: color,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewRoomButton extends StatelessWidget {
  AddNewRoomButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 10, 1),
      child: ButtonTheme(
        minWidth: 10,
        child: FlatButton(
          shape: StadiumBorder(),
          onPressed: () =>
              Navigator.of(context).pushNamed(AddRoomFormPage.routeName),
          color: Theme.of(context).accentColor,
          child: Text(
            "Add Room",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextFormField(
          onChanged: (value) {
            context.read<ItemsBloc>().add(SearchByLettersEvent(value));
          },
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
    );
  }
}

class SortDropdown extends StatelessWidget {
  const SortDropdown();

  _getDropdownValueFromState(state) {
    if (state is ItemsSortedAscAlpha) {
      return SortItemsAscAlphaEvent();
    } else if (state is ItemsSortedDescAlpha) {
      return SortItemsDescAlphaEvent();
    } else {
      return SortChronologicalEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (blocContext, state) {
            return DropdownButton(
              underline: Container(),
              value: _getDropdownValueFromState(state),
              items: [
                DropdownMenuItem(
                  child: FaIcon(FontAwesomeIcons.calendar),
                  value: SortChronologicalEvent(),
                ),
                DropdownMenuItem(
                  child: FaIcon(FontAwesomeIcons.sortAlphaDown),
                  value: SortItemsAscAlphaEvent(),
                ),
                DropdownMenuItem(
                  child: FaIcon(FontAwesomeIcons.sortAlphaUp),
                  value: SortItemsDescAlphaEvent(),
                ),
              ],
              onChanged: (event) {
                context.read<ItemsBloc>().add(event);
              },
            );
          },
        ),
      ),
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
        itemCount: state.itemsToDisplay.length + 1,
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
    Item item = state.itemsToDisplay[index - 1];

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              item.imagePath != null
                  ? Flexible(
                      flex: 2,
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
              Flexible(
                flex: 1,
                child: Container(
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
      onTap: () => Navigator.of(context).pushNamed(AddItemCameraPage.routeName),
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
                "Add Item",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
