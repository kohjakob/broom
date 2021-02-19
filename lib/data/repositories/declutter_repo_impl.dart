import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class DeclutterRepoImpl implements DeclutterRepo {
  final LocalDatasource localDatasource;

  DeclutterRepoImpl({
    @required this.localDatasource,
  });

  @override
  Future<Either<Failure, Item>> addItem(Item item) async {
    try {
      final savedItem = await localDatasource.saveItemToDatabase(item);
      return Right(savedItem);
    } on ItemSaveFailException {
      return Left(Failure(Code.ItemSaveFail));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final items = await localDatasource.getItemsFromDatabase();
      return Right(items);
    } on NoItemsYetException {
      return Left(Failure(Code.NoItemsYet));
    }
  }
}
