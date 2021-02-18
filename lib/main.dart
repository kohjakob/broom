import 'dart:async';
import 'dart:io';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ownless2/screens/editScreen.dart';
import 'package:ownless2/screens/formScreen.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/items.dart';
import './providers/questions.dart';
import './screens/inventoryScreen.dart';
import './screens/howtoScreen.dart';
import './screens/swipeScreen.dart';
import 'screens/cameraScreen.dart';
import './screens/detailsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(Ownless());
}

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
    HowTo(),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined), label: "How To"),
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
