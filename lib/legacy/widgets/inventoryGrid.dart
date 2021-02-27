import 'package:flutter/material.dart';

import '../assets/constants.dart' as Constants;
import '../providers/item.dart';
import '../screens/cameraScreen.dart';
import 'inventoryItem.dart';

class InventoryGrid extends StatelessWidget {
  final List<Item> managedItems;
  InventoryGrid(this.managedItems);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(Constants.defaultPadding, 0,
          Constants.defaultPadding, Constants.defaultPadding),
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
                      onTap: () =>
                          Navigator.pushNamed(context, AddCamera.routeName),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constants.defaultBorderRadius)),
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
                                style:
                                    Theme.of(context).textTheme.subtitle2.apply(
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
                      managedItems[index - 1].title,
                      managedItems[index - 1].date,
                      managedItems[index - 1].imgUrl,
                      managedItems[index - 1].id,
                    );
            });
          },
          childCount: managedItems.length + 1,
        ),
      ),
    );
  }
}
