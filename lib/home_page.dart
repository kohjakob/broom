import 'package:broom/presentation/pages/swipe_page.dart';
import 'package:flutter/material.dart';

import 'presentation/pages/grid_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomNavigationPageIndex;
  final bottomNavigationPages = [
    GridPage(),
    SwipePage(),
  ];

  @override
  void initState() {
    super.initState();
    bottomNavigationPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Swipe",
          ),
        ],
        currentIndex: bottomNavigationPageIndex,
        onTap: (tappedItemIndex) {
          setState(() {
            bottomNavigationPageIndex = tappedItemIndex;
          });
        },
      ),
      body: SafeArea(
        child: bottomNavigationPages[bottomNavigationPageIndex],
      ),
    );
  }
}
