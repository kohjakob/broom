import 'package:broom/domain/entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';

class GetRooms {
  final DeclutterRepo repo;

  GetRooms(this.repo);

  Future<Either<Failure, List<Room>>> execute() async {
    final either = await repo.getRooms();
    return either.fold(
      (failure) => Left(failure),
      (rooms) => Right(rooms),
    );
  }
}
