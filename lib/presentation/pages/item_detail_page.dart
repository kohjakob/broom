import 'package:broom/core/constants/colors.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/presentation/bloc/grid_cubit.dart';
import 'package:broom/presentation/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailPage extends StatelessWidget {
  static String routeName = "itemDetailPage";

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final Item item = arguments["item"];
    return Scaffold(
      appBar: TopNavBar(
        showBack: true,
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Text(item.name),
        ),
      ),
    );
  }
}
