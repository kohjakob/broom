import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HowTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        centerTitle: true,
        title: Text(
          "How To",
          style: TextStyle(color: Colors.indigo.shade500),
        ),
        toolbarHeight: 55,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Text("Here you will find decluttering-guides later"),
        ),
      ),
    );
  }
}
