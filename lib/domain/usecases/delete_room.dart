import '../../core/errorhandling/exceptions.dart';
import '../entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../repositories/declutter_repo.dart';
import '../../core/errorhandling/failures.dart';
import '../entities/item.dart';

class DeleteRoom {
  final DeclutterRepo repo;

  DeleteRoom(this.repo);

  Future<Either<Failure, bool>> execute({
    @required int id,
    @required bool keepItems,
  }) async {
    final either = await repo.deleteRoom(id, keepItems);
    return either.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}
