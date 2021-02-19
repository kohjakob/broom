import 'package:flutter/material.dart';

import '../assets/orderCategory.dart';

class OrderDropdown extends StatefulWidget {
  final Function handleOrderChange;
  OrderDropdown(this.handleOrderChange);

  @override
  OrderDropdownState createState() => OrderDropdownState();
}

class OrderDropdownState extends State<OrderDropdown> {
  String dropdownValue = "Latest";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.expand_more),
      underline: Container(),
      iconSize: 24,
      elevation: 16,
      isDense: true,
      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
      onChanged: (String order) {
        setState(() {
          dropdownValue = order;
        });
        if (order == "Latest") widget.handleOrderChange(OrderCategory.latest);
        if (order == "Alphabetic") widget.handleOrderChange(OrderCategory.alphabetical);
      },
      items: [
        DropdownMenuItem<String>(
          value: "Latest",
          child: Text("Latest"),
        ),
        DropdownMenuItem<String>(
          value: "Alphabetic",
          child: Text("Alphabetic"),
        ),
        DropdownMenuItem<String>(
          value: "Worst",
          child: Text("Worst rated"),
        ),
        DropdownMenuItem<String>(
          value: "Best",
          child: Text("Best rated"),
        )
      ],
    );
  }
}
