import 'package:broom/domain/entities/item.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/bloc/swipe_cubit.dart';
import 'package:broom/presentation/pages/grid_page_widgets/loading_fallback.dart';
import 'package:broom/presentation/pages/item_detail_page.dart';
import 'package:broom/presentation/pages/swipe_page_widgets/question.dart';
import 'package:broom/presentation/pages/swipe_page_widgets/skip_card.dart';
import 'package:broom/presentation/pages/swipe_page_widgets/swipe_background.dart';
import 'package:broom/presentation/pages/swipe_page_widgets/swipeable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with TickerProviderStateMixin {
  AnimationController swipeAnimationController;
  double directionVector = 0;
  Offset startOffset = Offset(0, 0);
  Offset updateOffset = Offset(0, 0);
  bool skip = false;

  @override
  void initState() {
    super.initState();
    context.read<SwipeCubit>().fetchPlayPile();
    swipeAnimationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    swipeAnimationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    swipeAnimationController.dispose();
    super.dispose();
  }

  bool _velosityIsHighEnough(DragEndDetails drag) {
    print(updateOffset.direction.abs());
    print(drag.velocity.pixelsPerSecond.distance);
    return (updateOffset.direction.abs() > 0.7) &&
        (drag.velocity.pixelsPerSecond.distance > 1000);
  }

  void _onPanStart(DragStartDetails drag) {
    startOffset = drag.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails drag) {
    Offset offset = updateOffset - startOffset;
    updateOffset = drag.globalPosition;
    swipeAnimationController.value = offset.distance;
    directionVector = offset.direction;
  }

  bool _isRightDrag(dragDirection) {
    return 1 > dragDirection && dragDirection > -1.5;
  }

  void _onPanEnd(DragEndDetails drag, Item item) {
    if (_velosityIsHighEnough(drag)) {
      // Animate out the card
      swipeAnimationController.animateWith(
        FrictionSimulation(
          1.1,
          swipeAnimationController.value,
          drag.velocity.pixelsPerSecond.distance,
        ),
      );

      swipeAnimationController.value = 0;
      if (_isRightDrag(directionVector)) {
        context.read<SwipeCubit>().swipeRight(item);
      } else {
        context.read<SwipeCubit>().swipeLeft(item);
      }
    } else {
      // Animate card back to center
      swipeAnimationController.animateWith(
        SpringSimulation(
          SpringDescription(mass: 2, stiffness: 20, damping: 3),
          swipeAnimationController.value,
          0,
          drag.velocity.pixelsPerSecond.distance,
        ),
      );
    }
  }

  Widget buildSwipeIndicator() {
    if (skip) return Container();

    var ratio = (swipeAnimationController.value).abs() / 100;
    ratio = ratio <= 0 ? 0 : ratio;
    ratio = ratio > 1 ? 1 : ratio;
    ratio = ratio <= 0.4 ? 0 : ratio;

    if (1 > directionVector && directionVector > -1.5) {
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

  void skipAnswer() {
    var animationFuture = this
        .swipeAnimationController
        .animateTo(-600, duration: Duration(milliseconds: 300));
    animationFuture.whenComplete(() {
      swipeAnimationController.value = 0;
      context.read<SwipeCubit>().skipCard();
    });
  }

  _buildChildren(SwipeLoaded swipeState) {
    return [
      (swipeState.allItems.length >= 2)
          ? SwipeableCard(swipeState.allItems.elementAt(1))
          : Container(),
      AnimatedBuilder(
        animation: swipeAnimationController,
        builder: (context, snapshot) {
          return Transform.translate(
            offset: Offset.fromDirection(
              directionVector,
              swipeAnimationController.value,
            ),
            child: GestureDetector(
              onPanStart: (details) => _onPanStart(details),
              onPanUpdate: (details) => _onPanUpdate(details),
              onPanEnd: (details) => _onPanEnd(details, swipeState.topItem),
              onTap: () {
                context
                    .read<ItemDetailCubit>()
                    .setItem(swipeState.topItem, swipeState.topItem.roomId);
                Navigator.of(context).pushNamed(ItemDetailPage.routeName);
              },
              child: SwipeableCard(swipeState.topItem),
            ),
          );
        },
      ),
    ];
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
                      Question(),
                      SizedBox(height: 15),
                      Expanded(
                        child: Stack(
                          children: [
                            SkipCard(skipAnswer),
                            Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: _buildChildren(swipeState),
                                  ),
                                ),
                                SizedBox(height: 41),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (swipeState is SwipedThrough) {
                  return SwipeBackground();
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
