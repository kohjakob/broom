import 'package:broom/domain/entities/item.dart';
import 'package:dartz/dartz.dart';

import '../../core/errorhandling/failures.dart';
import '../repositories/declutter_repo.dart';

class GetItems {
  final DeclutterRepo repo;

  GetItems(this.repo);

  Future<Either<Failure, List<Item>>> execute() async {
    final either = await repo.getItems();
    return either.fold(
      (failure) => Left(failure),
      (items) => Right(items),
    );
  }
}
