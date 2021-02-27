import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final IconData icon;
  final Color color;

  SmallButton({
    this.onPressed,
    this.label,
    this.icon,
    this.color = Colors.indigoAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return FlatButton.icon(
        color: color,
        shape: StadiumBorder(),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return FlatButton(
        minWidth: 10,
        color: color,
        shape: StadiumBorder(),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
