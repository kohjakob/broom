import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final IconData iconData;
  final Color color;

  SmallButton(this.onPressed, this.label, this.iconData, this.color);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      color: color,
      shape: StadiumBorder(),
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
