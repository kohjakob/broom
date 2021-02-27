import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../assets/constants.dart' as Constants;
import 'inventoryDropdown.dart';

class ActionBar extends StatelessWidget {
  final Function handleOrderChange;
  final Function handleSearch;
  ActionBar(this.handleOrderChange, this.handleSearch);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: ActionBarDelegate(
        70,
        70,
        handleOrderChange,
        handleSearch,
      ),
    );
  }
}

class ActionBarDelegate implements SliverPersistentHeaderDelegate {
  double minExtentDelegate;
  double maxExtentDelegate;
  Function handleOrderChange;
  Function handleSearch;
  ActionBarDelegate(this.minExtentDelegate, this.maxExtentDelegate,
      this.handleOrderChange, this.handleSearch);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: minExtent,
      width: 100,
      color: Colors.indigo.shade50.withOpacity(shrinkOffset / 70),
      //color: Colors.red,
      padding: EdgeInsets.fromLTRB(
          Constants.defaultPadding, 20, Constants.defaultPadding, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 60,
              child: TextFormField(
                onChanged: (fieldValue) => handleSearch(fieldValue),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.3,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 9),
                  labelText: "Search item",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          SizedBox(width: 20),
          OrderDropdown(handleOrderChange),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(ActionBarDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      null;

  @override
  TickerProvider get vsync => null;

  @override
  double get maxExtent => maxExtentDelegate;

  @override
  double get minExtent => minExtentDelegate;
}
