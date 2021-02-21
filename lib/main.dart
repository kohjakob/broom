import 'package:broom/injector.dart';
import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/pages/camera_page.dart';
import 'package:broom/presentation/pages/form_page.dart';
import 'package:broom/presentation/pages/grid_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(Broom());
}

class Broom extends StatelessWidget {
  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemsBloc>(
          create: (_) => injector<ItemsBloc>(),
        ),
        BlocProvider<CameraBloc>(
          create: (_) => injector<CameraBloc>(),
        ),
      ],
      child: MaterialApp(
        routes: {
          GridPage.routeName: (ctx) => GridPage(),
          FormPage.routeName: (ctx) => FormPage(),
          CameraPage.routeName: (ctx) => CameraPage(),
        },
        home: Scaffold(
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
          ),
          body: SafeArea(
            child: GridPage(),
          ),
        ),
      ),
    );
  }
}
