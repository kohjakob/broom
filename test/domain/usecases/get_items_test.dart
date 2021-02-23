import 'package:broom/domain/usecases/get_items.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:uuid/uuid.dart';

class MockDeclutterRepo extends Mock implements DeclutterRepo {}

void main() {
  GetItems usecase;
  MockDeclutterRepo repo;

  setUp(() {
    repo = MockDeclutterRepo();
    usecase = GetItems(repo);
  });

  test(
    'should return Left(Failure(Code.NoItemsYet)) if there are no items stored in the database yet',
    () async {
      // arrange
      when(repo.getItems())
          .thenAnswer((_) async => Left(Failure(Code.NoItemsYet)));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Left(Failure(Code.NoItemsYet)));
    },
  );

  test(
    'should return Right(List<Item>) where the order of items is reversed if there are items stored in the database',
    () async {
      // arrange
      final itemList = [
        Item(
          name: "Phone",
          description: "Holds up pretty well",
          id: 1,
          imagePath: null,
        ),
        Item(
          name: "Levis",
          description: "Very used but still good",
          id: 1,
          imagePath: null,
        ),
      ];
      when(repo.getItems()).thenAnswer((_) async => Right(itemList));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(itemList.reversed.toList()));
    },
  );
}
