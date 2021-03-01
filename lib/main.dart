import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/pages/edit_item_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';
import 'injector.dart';
import 'presentation/bloc/grid_cubit.dart';
import 'presentation/pages/add_item_camera_page.dart';
import 'presentation/pages/add_item_form_page.dart';
import 'presentation/pages/add_room_form_page.dart';
import 'presentation/pages/edit_room_form_page.dart';
import 'presentation/pages/item_detail_page.dart';

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
        BlocProvider<GridCubit>(
          create: (_) => injector<GridCubit>(),
        ),
        BlocProvider<ItemDetailCubit>(
          create: (_) => injector<ItemDetailCubit>(),
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
          AddItemFormPage.routeName: (ctx) => AddItemFormPage(),
          AddItemCameraPage.routeName: (ctx) => AddItemCameraPage(),
          AddRoomFormPage.routeName: (ctx) => AddRoomFormPage(),
          EditRoomFormPage.routeName: (ctx) => EditRoomFormPage(),
          ItemDetailPage.routeName: (ctx) => ItemDetailPage(),
          EditItemFormPage.routeName: (ctx) => EditItemFormPage(),
        },
        home: HomePage(),
      ),
    );
  }
}
