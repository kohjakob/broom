import 'package:broom/injector.dart';
import 'package:broom/presentation/bloc/camera_cubit.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/pages/add_item_camera_page.dart';
import 'package:broom/presentation/pages/add_item_form_page.dart';
import 'package:broom/presentation/pages/add_room_form_page.dart';
import 'package:broom/presentation/pages/edit_room_form_page.dart';
import 'package:broom/presentation/pages/home_page.dart';
import 'package:broom/presentation/pages/item_detail_page.dart';
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
        BlocProvider<GridCubit>(
          create: (_) => injector<GridCubit>(),
        ),
        BlocProvider<CameraCubit>(
          create: (_) => injector<CameraCubit>(),
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
        },
        home: HomePage(),
      ),
    );
  }
}
