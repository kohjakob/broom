import 'dart:io';

import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/swipe_cubit.dart';
import 'package:broom/presentation/pages/grid_page_widgets/loading_fallback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(30),
            child: BlocBuilder<SwipeCubit, SwipeState>(
              builder: (swipeContext, swipeState) {
                if (swipeState is SwipeLoaded) {
                  return Stack(
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
                      ...swipeState.items.map(
                        (item) {
                          return SwipeableCard(item);
                        },
                      ).toList(),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.overlay,
                ),
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
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Container()),
                        Text(
                          widget.item.name,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.0),
                                blurRadius: 15.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.item.description,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.0),
                                blurRadius: 15.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
