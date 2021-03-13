import 'package:flutter/material.dart';

class SkipCard extends StatelessWidget {
  const SkipCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Skip answer",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward,
            color: Colors.grey,
            size: 15,
          ),
        ],
      ),
    );
  }
}
