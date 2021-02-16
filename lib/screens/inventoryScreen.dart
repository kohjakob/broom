import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/orderCategory.dart';
import '../providers/items.dart';
import '../providers/item.dart';
import '../widgets/inventoryGrid.dart';
import '../widgets/alertDismissable.dart';
import '../widgets/inventoryActionBar.dart';
import '../assets/constants.dart' as Constants;
import '../widgets/inventoryItem.dart';
import '../screens/cameraScreen.dart';

class Inventory extends StatefulWidget {
  static const routeName = "/inventory";

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Item> _displayItems = [];
  bool _init = false;
  OrderCategory _order = OrderCategory.latest;
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final _items = Provider.of<Items>(context);
    _displayItems = _items.getItemsByOrderAndSearchQuery(_order, _searchQuery);

    if (!_init) {
      setState(() {
        Provider.of<Items>(context, listen: false).fetchAndSetItems();
        _init = true;
        _displayItems = _items.getItemsByOrderAndSearchQuery(_order, _searchQuery);
      });
    }

    _handleOrderChange(OrderCategory newOrder) {
      setState(() {
        _order = newOrder;
        _displayItems = _items.getItemsByOrderAndSearchQuery(newOrder, _searchQuery);
      });
    }

    _handleSearch(String newSearchQuery) {
      setState(() {
        _searchQuery = newSearchQuery;
        _displayItems = _items.getItemsByOrderAndSearchQuery(_order, newSearchQuery);
      });
    }

    return !_init
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                DismissableAlert(
                  "Don't know where to begin?",
                  "If there is something in your pocket start with that!",
                  Colors.orange.shade300,
                ),
                ActionBar(_handleOrderChange, _handleSearch),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(Constants.defaultPadding, 0, Constants.defaultPadding, Constants.defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return LayoutBuilder(builder: (context, constraints) {
                          return index == 0
                              ? GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, AddCamera.routeName),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade100,
                                      borderRadius: BorderRadius.all(Radius.circular(Constants.defaultBorderRadius)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: constraints.maxWidth / 2,
                                          color: Colors.indigo.shade400,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.cover,
                                          child: Text(
                                            "Add new \nitem",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.subtitle2.apply(
                                                  color: Colors.indigo.shade500,
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GridItem(
                                  constraints,
                                  _displayItems[index - 1].title,
                                  _displayItems[index - 1].date,
                                  _displayItems[index - 1].imgUrl,
                                  _displayItems[index - 1].id,
                                );
                        });
                      },
                      childCount: _displayItems.length + 1,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
