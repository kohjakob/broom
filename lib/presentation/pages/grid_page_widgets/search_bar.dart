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
            hintText: "Search items or rooms",
            prefixIcon: Icon(Icons.search),
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
