import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should throw InsufficientItemInfoException if trying to create an item model with empty name',
    () async {
      // arrange
      // act
      try {
        ItemModel(
            id: "6c84fb90-12c4-11e1-840d-7b25c5ee775a",
            name: "Book about yoga",
            description: "");
      }
      // assert
      catch (e) {
        expect(e, isInstanceOf<InsufficientItemInfoException>());
      }
    },
  );
}
