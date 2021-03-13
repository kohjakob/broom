import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../domain/entities/room.dart';

class RoomButton extends StatelessWidget {
  final Function onPressed;
  final Room room;
  final int count;
  final bool selected;

  RoomButton({
    this.onPressed,
    this.room,
    this.count,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        (room == null) ? Theme.of(context).accentColor : room.color.material;
    final label = (room == null) ? "All" : room.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 10, 1),
      child: TextButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(10, 0)),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(color.withAlpha(20)),
          overlayColor: MaterialStateProperty.all(color.withAlpha(20)),
          foregroundColor: MaterialStateProperty.all(color.withAlpha(20)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: color),
            ),
            SizedBox(width: 5),
            Container(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: color,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            )
          ],
        ),
      ),
    );
  }
}
