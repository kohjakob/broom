import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/bloc/swipe_cubit.dart';
import 'package:broom/presentation/pages/grid_page_widgets/loading_fallback.dart';
import 'package:broom/presentation/pages/item_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: BlocBuilder<SwipeCubit, SwipeState>(
              builder: (swipeContext, swipeState) {
                if (swipeState is SwipeLoaded) {
                  return Column(
                    children: [
                      SizeTransition(
                        sizeFactor: _animation,
                        axis: Axis.vertical,
                        axisAlignment: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(30),
                              color: Colors.indigo.shade50,
                              alignment: Alignment.center,
                              child: Text(
                                "Did you use this item in the last week?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo.shade500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
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
                            Stack(
                              children: [
                                Center(
                                  child: FlatButton(
                                    color: Theme.of(context).accentColor,
                                    shape: StadiumBorder(),
                                    child: Text(
                                      "Reload",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.white),
                                    ),
                                    onPressed: () =>
                                        context.read<SwipeCubit>().fetchItems(),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ...swipeState.items.map(
                                            (item) {
                                              return SwipeableCard(item);
                                            },
                                          ).toList(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 41),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return LoadingFallback();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SwipeableCard extends StatefulWidget {
  final Item item;
  SwipeableCard(this.item);
  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
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

  @override
  void dispose() {
    dragController.dispose();
    super.dispose();
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
      if (1 > dragDirection && dragDirection > -1.5) {
        context.read<SwipeCubit>().swipeRight();
      } else {
        context.read<SwipeCubit>().swipeLeft();
      }
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
    return AnimatedBuilder(
      animation: dragController,
      builder: (context, snapshot) {
        return Transform.translate(
          offset: Offset.fromDirection(dragDirection, dragController.value),
          child: GestureDetector(
            onPanStart: (details) => _onPanStart(details),
            onPanUpdate: (details) => _onPanUpdate(details),
            onPanEnd: (details) => _onPanEnd(details),
            onTap: () {
              context
                  .read<ItemDetailCubit>()
                  .setItem(widget.item, widget.item.roomId);
              Navigator.of(context).pushNamed(ItemDetailPage.routeName);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: (widget.item.imagePath != null)
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(widget.item.imagePath)),
                              fit: BoxFit.cover,
                            ),
                          )
                        : BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                    child: Column(
                      children: [
                        Expanded(
                          child: (widget.item.imagePath == null)
                              ? Icon(
                                  Icons.image,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(100),
                                  size: 220,
                                )
                              : Container(),
                        ),
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).accentColor,
                          padding: EdgeInsets.fromLTRB(30, 25, 30, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 5),
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
                      ],
                    ),
                  ),
                ),
                Center(
                  child: buildSwipeIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
