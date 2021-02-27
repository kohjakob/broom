import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/grid_cubit.dart' as cubit;
import 'grid_page_widgets/item_grid.dart';
import 'grid_page_widgets/item_grid_header.dart';
import 'grid_page_widgets/loading_fallback.dart';
import 'grid_page_widgets/room_bar.dart';
import 'grid_page_widgets/search_bar.dart';
import 'grid_page_widgets/sort_dropdown.dart';

class GridPage extends StatelessWidget {
  static String routeName = "gridPage";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.GridCubit, cubit.GridState>(
      builder: (context, state) {
        if (state is cubit.GridLoaded) {
          return Column(
            children: [
              Container(
                color: Theme.of(context).accentColor.withAlpha(20),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  children: [
                    SearchBar(),
                    SizedBox(width: 20),
                    SortDropdown(),
                  ],
                ),
              ),
              RoomBar(state),
              ItemGridHeader(state),
              ItemGrid(state),
            ],
          );
        } else {
          return LoadingFallback();
        }
      },
    );
  }
}
