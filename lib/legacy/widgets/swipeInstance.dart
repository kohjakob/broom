import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../assets/constants.dart' as Constants;
import '../providers/item.dart';
import '../providers/question.dart';
import '../screens/detailsScreen.dart';

class SwipeInstance extends StatefulWidget {
  final Item item;
  final int itemZIndex;
  final Question question;
  final Function popItem;
  SwipeInstance(this.item, this.itemZIndex, this.question, this.popItem);

  @override
  _SwipeInstanceState createState() => _SwipeInstanceState();
}

class _SwipeInstanceState extends State<SwipeInstance>
    with SingleTickerProviderStateMixin {
  List<Color> questionColors = [
    Colors.indigo,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.amber,
    Colors.teal,
    Colors.red,
    Colors.blue,
  ];
  AnimationController dragController;
  double dragDirection = 0;
  Offset dragStartOffset = Offset(0, 0);
  Offset dragUpdateOffset = Offset(0, 0);
  bool skip = false;

  @override
  void initState() {
    super.initState();
    dragController = AnimationController.unbounded(vsync: this);
  }

  void addAnswer(double answer) {
    widget.item.addAnswer(answer, widget.question.id, widget.item.id);
    widget.popItem();
  }

  void skipAnswer() {
    setState(() {
      skip = true;
    });
    var animationFuture =
        dragController.animateTo(-600, duration: Duration(milliseconds: 300));
    animationFuture.whenComplete(() {
      widget.popItem();
    });
  }

  bool _checkVelocity(DragEndDetails dragDetails, Offset dragOffset) {
    Size screenSize = MediaQuery.of(context).size;
    return dragOffset.distance.abs() +
                dragDetails.velocity.pixelsPerSecond.distance.abs() >
            screenSize.width / 2 &&
        dragDetails.velocity.pixelsPerSecond.distance > 300;
  }

  void _onPanStart(DragStartDetails details) {
    dragStartOffset = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    dragUpdateOffset = details.globalPosition;
    Offset dragOffset = dragUpdateOffset - dragStartOffset;
    dragController.value = dragOffset.distance;
    dragDirection = dragOffset.direction;
  }

  void _onPanEnd(DragEndDetails deets) {
    Offset dragOffset = dragUpdateOffset - dragStartOffset;
    if (_checkVelocity(deets, dragOffset)) {
      FrictionSimulation frictionSim = FrictionSimulation(
          1.1, dragController.value, deets.velocity.pixelsPerSecond.distance);
      dragController.animateWith(frictionSim);
      dragController.addListener(handleNextSwipeable);
    } else {
      SpringDescription springDesc =
          SpringDescription(mass: 2, stiffness: 20, damping: 3);
      SpringSimulation springSim = SpringSimulation(springDesc,
          dragController.value, 0, deets.velocity.pixelsPerSecond.distance);
      dragController.animateWith(springSim);
    }
  }

  void handleNextSwipeable() {
    Size screenSize = MediaQuery.of(context).size;
    Offset cardOffset =
        Offset.fromDirection(dragDirection, dragController.value);
    if (cardOffset.dx.abs() > screenSize.width ||
        cardOffset.dy.abs() > screenSize.height) {
      dragController.stop();
      dragController.removeListener(handleNextSwipeable);
      if (1 > dragDirection && dragDirection > -1.5)
        addAnswer(1.0);
      else
        addAnswer(0);
    }
  }

  Widget buildSwipeIndicator() {
    if (skip) return Container();

    var ratio = (dragController.value).abs() / 100;
    ratio = ratio <= 0 ? 0 : ratio;
    ratio = ratio > 1 ? 1 : ratio;
    ratio = ratio <= 0.4 ? 0 : ratio;

    if (1 > dragDirection && dragDirection > -1.5) {
      return Opacity(
        opacity: ratio,
        child: CircleAvatar(
          radius: 60,
          child: Icon(
            Icons.thumb_up,
            size: 60,
          ),
        ),
      );
    } else {
      return Opacity(
        opacity: ratio,
        child: CircleAvatar(
          radius: 60,
          child: Icon(
            Icons.thumb_down,
            size: 60,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.itemZIndex < -5
        ? Container()
        : LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                // Question
                Positioned(
                  top: 0,
                  width: constraints.maxWidth,
                  height: 150,
                  child: Container(
                    margin: EdgeInsets.all(Constants.defaultPadding),
                    padding: EdgeInsets.fromLTRB(
                      Constants.defaultPadding + 10,
                      Constants.defaultPadding,
                      Constants.defaultPadding + 10,
                      Constants.defaultPadding,
                    ),
                    decoration: BoxDecoration(
                      color: questionColors[Random().nextInt(6)],
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.defaultBorderRadius)),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        widget.question.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .apply(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // CustomAnswer
                Positioned(
                  bottom: 0,
                  width: constraints.maxWidth,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => skipAnswer(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not sure, skip",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.indigo.shade200),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Colors.indigo.shade200,
                        ),
                      ],
                    ),
                  ),
                ),
                // Card
                Positioned(
                  top: 150,
                  bottom: 50,
                  width: constraints.maxWidth,
                  child: AnimatedBuilder(
                    animation: dragController,
                    builder: (context, snapshot) {
                      return Transform.translate(
                        offset: Offset.fromDirection(
                            dragDirection, dragController.value),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              Details.routeName,
                              arguments: widget.item.id),
                          onPanStart: (details) => _onPanStart(details),
                          onPanUpdate: (details) => _onPanUpdate(details),
                          onPanEnd: (details) => _onPanEnd(details),
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Constants.defaultPadding,
                                right: Constants.defaultPadding),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(widget.item.imgUrl)),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  Constants.defaultBorderRadius)),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(Constants.defaultPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        widget.item.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(child: buildSwipeIndicator()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          });
  }
}
