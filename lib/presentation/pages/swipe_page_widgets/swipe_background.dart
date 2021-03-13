import 'package:broom/presentation/bloc/swipe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipeBackground extends StatelessWidget {
  const SwipeBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).accentColor),
        ),
        child: Text(
          "Reload",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
        onPressed: () => context.read<SwipeCubit>().fetchPlayPile(),
      ),
    );
  }
}
