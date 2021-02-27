import '../../core/constants/colors.dart';
import '../entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../repositories/declutter_repo.dart';
import '../../core/errorhandling/failures.dart';

class AddRoom {
  final DeclutterRepo repo;

  AddRoom(this.repo);

  Future<Either<Failure, Room>> execute({
    @required String name,
    @required String description,
    @required CustomColor color,
  }) async {
    final room = Room(
      name: name,
      description: description,
      items: null,
      color: color,
    );

    final either = await repo.addRoom(room);

    return either.fold(
      (failure) => Left(failure),
      (room) => Right(room),
    );
  }
}
