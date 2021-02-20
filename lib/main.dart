import 'package:broom/injector.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
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
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ItemsBloc>(
            create: (_) => injector<ItemsBloc>(),
          ),
        ],
        child: Scaffold(
          body: SafeArea(
            child: GridPage(),
          ),
        ),
      ),
    );
  }
}
