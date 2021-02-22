import 'package:dartz/dartz.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

class GetItems {
  final DeclutterRepo repo;

  GetItems(this.repo);

  Future<Either<Failure, List<Item>>> execute() async {
    final either = await repo.getItems();
    return either.fold(
      (failure) => Left(failure),
      (items) => Right(items.reversed.toList()),
    );
  }
}
