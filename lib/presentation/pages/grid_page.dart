import 'package:broom/domain/entities/item.dart';
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
    return Text("No items yet");
  }
}

class ItemGrid extends StatelessWidget {
  final ItemsLoaded state;
  ItemGrid(this.state);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        child: GridView.builder(
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
          padding: EdgeInsets.all(20),
          color: Theme.of(context).primaryColor.withAlpha(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Text(
                item.description,
                style: Theme.of(context).textTheme.caption,
              ),
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
