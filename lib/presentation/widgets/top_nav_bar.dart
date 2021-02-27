import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final bool showBack;

  TopNavBar({this.actions, this.showBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Theme.of(context).primaryColor,
        ),
        Container(
          color: Theme.of(context).accentColor.withAlpha(20),
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            0,
          ),
          height: 60,
          child: Row(
            children: [
              GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              ...actions,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(400);
}

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
