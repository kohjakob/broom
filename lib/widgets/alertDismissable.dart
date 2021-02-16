import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import '../assets/constants.dart' as Constants;

class DismissableAlert extends StatefulWidget {
  final String title;
  final String description;
  final Color color;

  DismissableAlert(this.title, this.description, this.color);

  @override
  _DismissableAlertState createState() => _DismissableAlertState();
}

class _DismissableAlertState extends State<DismissableAlert> {
  var dismissed = false;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          dismissed
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Constants.defaultBorderRadius,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(
                    Constants.defaultPadding,
                    Constants.defaultPadding,
                    Constants.defaultPadding,
                    0,
                  ),
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                widget.title,
                                style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              widget.description,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            dismissed = true;
                          });
                        },
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
