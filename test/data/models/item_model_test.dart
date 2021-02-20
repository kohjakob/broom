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
        ItemModel(id: 0, name: "Book about yoga", description: "");
      }
      // assert
      catch (e) {
        expect(e, isInstanceOf<InsufficientItemInfoException>());
      }
    },
  );
}
