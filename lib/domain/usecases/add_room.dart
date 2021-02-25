import 'package:broom/core/constants/colors.dart';
import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

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
