import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/items.dart';
import 'providers/questions.dart';
import 'screens/inventoryScreen.dart';
import 'screens/swipeScreen.dart';
import 'screens/cameraScreen.dart';
import 'screens/detailsScreen.dart';
import 'screens/editScreen.dart';
import 'screens/formScreen.dart';

class Ownless extends StatefulWidget {
  CameraDescription camera;
  Ownless();

  @override
  _OwnlessState createState() => _OwnlessState();
}

class _OwnlessState extends State<Ownless> {
  var _currentIndex = 0;
  var _screens = [
    Inventory(),
    Swipe(),
  ];

  void _handleTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Items(),
        ),
        ChangeNotifierProvider(
          create: (context) => Questions(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Poppins",
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigoAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AddCamera.routeName: (ctx) => AddCamera(widget.camera),
          AddForm.routeName: (ctx) => AddForm(),
          Details.routeName: (ctx) => Details(),
          Inventory.routeName: (ctx) => Inventory(),
          EditForm.routeName: (ctx) => EditForm(),
        },
        home: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _handleTap,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view), label: "Inventory"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_outlined), label: "Swipe"),
            ],
          ),
          body: SafeArea(
            child: _screens[_currentIndex],
          ),
        ),
      ),
    );
  }
}
