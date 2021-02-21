import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final List<Widget> actions;

  TopNavBar(this.actions);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ...actions,
        ],
      ),
    );
  }
}
