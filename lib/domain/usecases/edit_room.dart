import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../core/constants/colors.dart';
import '../../core/errorhandling/failures.dart';
import '../entities/room.dart';
import '../repositories/declutter_repo.dart';

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
      name: (name == "") ? "Untitled" : name,
      description: (description == "") ? "No description" : description,
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
