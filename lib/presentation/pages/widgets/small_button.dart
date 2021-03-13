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
      return TextButton.icon(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).accentColor),
        ),
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
      return TextButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).accentColor),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
