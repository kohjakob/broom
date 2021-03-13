import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/grid_cubit.dart';

class SearchBar extends StatelessWidget {
  const SearchBar();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextFormField(
          onChanged: (query) {
            context.read<GridCubit>().searchItems(query);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search items or rooms",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.indigo.shade300,
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.indigo.shade300),
          ),
        ),
      ),
    );
  }
}
