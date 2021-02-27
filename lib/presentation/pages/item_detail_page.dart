import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';
import 'widgets/top_nav_bar.dart';

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
