import 'package:dartz/dartz.dart';

import '../../core/errorhandling/failures.dart';
import '../entities/room.dart';
import '../repositories/declutter_repo.dart';

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
