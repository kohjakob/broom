import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/domain/usecases/add_item.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

class MockDeclutterRepo extends Mock implements DeclutterRepo {}

void main() {
  AddItem usecase;
  MockDeclutterRepo repo;

  setUp(() {
    repo = MockDeclutterRepo();
    usecase = AddItem(repo);
  });

  test(
    'should return Left(Failure(Code.InsufficientItemInfo)) if no item executed with empty name',
    () async {
      // arrange
      // act
      final result =
          await usecase.execute(name: "", description: "description given");
      // assert
      expect(result, Left(Failure(Code.InsufficientItemInfo)));
    },
  );

  test(
    'should return Left(Failure(Code.InsufficientItemInfo)) if no item executed with empty description',
    () async {
      // arrange
      // act
      final result = await usecase.execute(name: "name given", description: "");
      // assert
      expect(result, Left(Failure(Code.InsufficientItemInfo)));
    },
  );

  test(
    'should return added Item if adding it adding it via the repo worked',
    () async {
      // arrange
      final item = Item(
          id: 1,
          name: "Belt",
          description: "Old belt i stole from my father last christmas");
      when(repo.addItem(any)).thenAnswer((_) async => Right(item));
      // act
      final result = await usecase.execute(
          name: "Belt",
          description: "Old belt i stole from my father last christmas");
      // assert
      expect(result, Right(item));
    },
  );
}
