import 'package:broom/core/constants/colors.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';

class EditRoom {
  final DeclutterRepo repo;

  EditRoom(this.repo);

  Future<Either<Failure, Room>> execute({
    @required int roomId,
    @required String name,
    @required String description,
    @required CustomColor color,
  }) async {
    final room = Room(
      id: roomId,
      name: name,
      description: description,
      items: null,
      color: color,
    );

    final either = await repo.editRoom(room);

    return either.fold(
      (failure) => Left(failure),
      (room) => Right(room),
    );
  }
}
