import 'package:flutter/cupertino.dart';

import 'add_new_item_tile.dart';

class NoItemsFallback extends StatelessWidget {
  const NoItemsFallback();

  @override
  Widget build(BuildContext context) {
    return AddNewItemTile(null);
  }
}
