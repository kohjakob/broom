import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:broom/data/repositories/declutter_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/core/errorhandling/failures.dart';

class MockLocalDatasource extends Mock implements LocalDatasource {}

void main() {
  DeclutterRepoImpl repo;
  MockLocalDatasource mockLocalDatasource;

  setUp(() {
    mockLocalDatasource = MockLocalDatasource();
    repo = DeclutterRepoImpl(
      localDatasource: mockLocalDatasource,
    );
  });

  test(
    'should return the saved Right(Item) if saving the item worked',
    () async {
      // arrange
      final itemToSave = Item(
          id: "6c84fb90-12c4-11e1-840d-7b25c5ee775a",
          name: "Belt",
          description: "Old belt i stole from my father last christmas");
      final savedItem = ItemModel(
          id: "6c84fb90-12c4-11e1-840d-7b25c5ee775a",
          name: "Belt",
          description: "Old belt i stole from my father last christmas");
      when(mockLocalDatasource.saveItemToDatabase(any))
          .thenAnswer((_) async => savedItem);
      // act
      final result = await repo.addItem(itemToSave);
      // assert
      expect(result, Right(savedItem));
    },
  );

  test(
    'should return the Left(Failure(Code.ItemSaveFail)) if saving the item didnt work',
    () async {
      // arrange
      final itemToSave = Item(
          id: "6c84fb90-12c4-11e1-840d-7b25c5ee775a",
          name: "Belt",
          description: "Old belt i stole from my father last christmas");
      when(mockLocalDatasource.saveItemToDatabase(any))
          .thenThrow(ItemSaveFailException());
      // act
      final result = await repo.addItem(itemToSave);
      // assert
      expect(result, Left(Failure(Code.ItemSaveFail)));
    },
  );
}
