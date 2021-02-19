import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

class MockQuestionsBox extends Mock implements Box {}

class MockItemsBox extends Mock implements Box {}

void main() {
  MockQuestionsBox questions;
  MockItemsBox items;
  LocalDatasource localDatasource;

  setUp(() {
    questions = MockQuestionsBox();
    items = MockItemsBox();
    localDatasource = LocalDatasourceImpl(items, questions);
  });

  group(
    'saveItemToDatabase',
    () => {
      test(
        'should build, store and return ItemModel from passed in Item',
        () async {
          // arrange
          final itemModel = ItemModel(
            name: "Blanket",
            description: "Just a regular wool blanket",
            id: Uuid().v4(),
          );
          when(items.add(any)).thenAnswer((_) async => 0);
          when(items.get(0)).thenReturn(itemModel);
          // act
          final result = await localDatasource.saveItemToDatabase(Item(
            name: "Blanket",
            description: "Just a regular wool blanket",
          ));
          // assert
          expect(result, itemModel);
        },
      )
    },
  );

  group(
    'getItemsFromDatabase',
    () => {
      test(
        'should throw NoItemsYetException if there are no items in the database',
        () async {
          // arrange
          when(items.isEmpty).thenReturn(true);
          when(items.values).thenThrow(NoItemsYetException());
          // act
          try {
            await localDatasource.getItemsFromDatabase();
          }
          // assert
          catch (e) {
            expect(e, isInstanceOf<NoItemsYetException>());
          }
        },
      ),
      test(
        'should return List<ItemModel> of the items stored in the database if there are any',
        () async {
          // arrange
          final models = [
            ItemModel(
              name: "Blanket",
              description: "Just a regular wool blanket",
              id: Uuid().v4(),
            ),
            ItemModel(
              name: "Glasses",
              description: "These i use every every every day",
              id: Uuid().v4(),
            )
          ];
          when(items.isEmpty).thenReturn(false);
          when(items.values).thenAnswer((_) => models);
          // act
          final result = await localDatasource.getItemsFromDatabase();

          // assert
          expect(result, models);
        },
      )
    },
  );
}
