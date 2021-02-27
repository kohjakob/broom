import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/pages/add_item_camera_page.dart';
import 'package:broom/presentation/pages/add_room_form_page.dart';
import 'package:broom/presentation/pages/edit_room_form_page.dart';
import 'package:broom/presentation/pages/item_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:broom/core/constants/colors.dart';
import 'package:broom/domain/entities/room.dart';

class GridPage extends StatelessWidget {
  static String routeName = "gridPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) {
        if (state is GridLoaded) {
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
              ItemGridHeader(state),
              ItemGrid(state),
            ],
          );
        } else {
          return LoadingFallback();
        }
      },
    );
  }
}

class ItemGridHeader extends StatelessWidget {
  final GridLoaded state;
  const ItemGridHeader(this.state);

  _editRoom(context) {
    Navigator.of(context).pushNamed(EditRoomFormPage.routeName,
        arguments: {"roomToEdit": state.roomSelected});
  }

  _deleteRoomDialog(context) {
    final deleteDialog = AlertDialog(
      title: Text("Really delete this room?"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(value: false, onChanged: null),
                Expanded(child: Text("Delete all items in this room"))
              ],
            )
          ],
        ),
      ),
      actions: [
        FlatButton(onPressed: null, child: Text("No")),
        FlatButton(onPressed: null, child: Text("Yes")),
      ],
    );
    showDialog(context: context, child: deleteDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              (state.roomSelected == null)
                  ? state.displayItems.length == 0
                      ? "No items yet"
                      : "All your items"
                  : state.roomSelected.name,
              style: Theme.of(context).textTheme.headline5),
          Row(
            children: (state.roomSelected == null)
                ? []
                : [
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editRoom(context)),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteRoomDialog(context)),
                  ],
          )
        ],
      ),
    );
  }
}

class RoomBar extends StatelessWidget {
  const RoomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(0),
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      height: 65,
      child: BlocBuilder<GridCubit, GridState>(
        builder: (roomContext, state) {
          if (state is GridLoaded) {
            return ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 20),
                AddNewRoomButton(),
                RoomButton(
                  selected: (state.roomSelected == null),
                  room: null,
                  count: state.displayItems.length,
                  onPressed: () => context.read<GridCubit>().filterItems(null),
                ),
                ...state.rooms.map(
                  (room) {
                    if (room.id != -1) {
                      return RoomButton(
                        selected: (state.roomSelected == room),
                        room: room,
                        count: room.items.length,
                        onPressed: () =>
                            context.read<GridCubit>().filterItems(room),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(width: 20),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class LoadingFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class RoomButton extends StatelessWidget {
  final Function onPressed;
  final Room room;
  final int count;
  final bool selected;

  RoomButton({
    this.onPressed,
    this.room,
    this.count,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        (room == null) ? Theme.of(context).accentColor : room.color.material;
    final label = (room == null) ? "All" : room.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 10, 1),
      child: FlatButton(
        minWidth: 10,
        color: selected ? color.withAlpha(40) : Colors.transparent,
        highlightColor: color.withAlpha(20),
        splashColor: color.withAlpha(20),
        shape: StadiumBorder(),
        onPressed: onPressed,
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
          onChanged: (query) {
            context.read<GridCubit>().searchItems(query);
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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: BlocBuilder<GridCubit, GridState>(
          builder: (blocContext, state) {
            if (state is GridLoaded) {
              return DropdownButton(
                underline: Container(),
                value: state.sorting,
                items: [
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.calendar,
                    ),
                    value: ItemSorting.AscendingDate,
                  ),
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.sortAlphaDown,
                    ),
                    value: ItemSorting.AscendingAlphaName,
                  ),
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.sortAlphaUp,
                    ),
                    value: ItemSorting.DescendingAlphaName,
                  ),
                ],
                onChanged: (sorting) {
                  context.read<GridCubit>().sortItems(sorting);
                },
              );
            } else {
              return Container();
            }
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
    return AddNewItemTile(null);
  }
}

class ItemGrid extends StatelessWidget {
  final GridLoaded state;
  ItemGrid(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        children: [
          AddNewItemTile(state.roomSelected),
          ...state.displayItems
              .where((displayItem) {
                return (displayItem.searchMatch && displayItem.roomFilterMatch);
              })
              .toList()
              .map((item) => ItemTile(item))
              .toList()
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final DisplayItem displayItem;
  ItemTile(this.displayItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(ItemDetailPage.routeName, arguments: {
        "item": displayItem.item,
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: Theme.of(context).primaryColor.withAlpha(15),
          child: Column(
            children: [
              displayItem.item.imagePath != null
                  ? Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withAlpha(30),
                          image: DecorationImage(
                            image: FileImage(
                              File(displayItem.item.imagePath),
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
                  color: Theme.of(context).primaryColor.withAlpha(15),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        displayItem.item.name,
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
  final Room roomSelected;

  const AddNewItemTile(this.roomSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AddItemCameraPage.routeName,
        arguments: {"intendedRoom": roomSelected},
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          color: (roomSelected == null)
              ? Theme.of(context).accentColor
              : roomSelected.color.material,
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
                (roomSelected == null)
                    ? "Add Item"
                    : "Add Item to\n" + roomSelected.name,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
