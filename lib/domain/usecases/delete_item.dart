import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../repositories/declutter_repo.dart';
import '../../core/errorhandling/failures.dart';

class DeleteItem {
  final DeclutterRepo repo;

  DeleteItem(this.repo);

  Future<Either<Failure, bool>> execute({
    @required int id,
  }) async {
    final either = await repo.deleteItem(id);
    return either.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}
