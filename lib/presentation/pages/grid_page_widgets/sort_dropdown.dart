import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/grid_cubit.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: BlocBuilder<GridCubit, GridState>(
          builder: (blocContext, state) {
            if (state is GridLoaded) {
              return DropdownButton(
                underline: Container(),
                value: state.sorting,
                items: [
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.calendar,
                      color: Colors.indigo.shade400,
                    ),
                    value: ItemSorting.AscendingDate,
                  ),
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.sortAlphaDown,
                      color: Colors.indigo.shade400,
                    ),
                    value: ItemSorting.AscendingAlphaName,
                  ),
                  DropdownMenuItem(
                    child: FaIcon(
                      FontAwesomeIcons.sortAlphaUp,
                      color: Colors.indigo.shade400,
                    ),
                    value: ItemSorting.DescendingAlphaName,
                  ),
                ],
                onChanged: (sorting) {
                  context.read<GridCubit>().sortItems(sorting);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
