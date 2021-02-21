import 'package:broom/presentation/pages/grid_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomNavigationPageIndex;
  final bottomNavigationPages = [
    GridPage(),
    GridPage(),
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
        toolbarHeight: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Rate items",
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
