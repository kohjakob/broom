import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final bool showBack;
  final Function onBackPressed;

  TopNavBar({
    @required this.actions,
    @required this.showBack,
    @required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Theme.of(context).primaryColorLight,
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
                onTap: () => onBackPressed(),
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
