import 'package:flutter/cupertino.dart';

import 'add_new_item_button.dart';

class NoItemsFallback extends StatelessWidget {
  const NoItemsFallback();

  @override
  Widget build(BuildContext context) {
    return AddNewItemButton(null);
  }
}
