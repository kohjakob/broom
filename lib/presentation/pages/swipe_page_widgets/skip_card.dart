import 'package:flutter/material.dart';

class SkipCard extends StatelessWidget {
  final Function skipAnswer;
  const SkipCard(this.skipAnswer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => skipAnswer(),
      child: Container(
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
      ),
    );
  }
}
