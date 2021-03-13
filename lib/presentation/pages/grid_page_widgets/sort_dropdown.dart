import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/grid_cubit.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 8, 12, 8),
          child: BlocBuilder<GridCubit, GridState>(
            builder: (blocContext, state) {
              if (state is GridLoaded) {
                return DropdownButton(
                  iconEnabledColor: Colors.indigo.shade300,
                  iconDisabledColor: Colors.indigo.shade300,
                  icon: Icon(
                    Icons.arrow_downward,
                    size: 15,
                  ),
                  elevation: 1,
                  isDense: true,
                  underline: Container(),
                  value: state.sorting,
                  items: [
                    DropdownMenuItem(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FaIcon(
                          FontAwesomeIcons.calendar,
                          color: Colors.indigo.shade300,
                          size: 20,
                        ),
                      ),
                      value: ItemSorting.AscendingDate,
                    ),
                    DropdownMenuItem(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FaIcon(
                          FontAwesomeIcons.sortAlphaDown,
                          color: Colors.indigo.shade300,
                          size: 20,
                        ),
                      ),
                      value: ItemSorting.AscendingAlphaName,
                    ),
                    DropdownMenuItem(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FaIcon(
                          FontAwesomeIcons.sortAlphaUp,
                          color: Colors.indigo.shade300,
                          size: 20,
                        ),
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
      ),
    );
  }
}
