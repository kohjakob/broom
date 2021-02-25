import 'package:broom/domain/entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

abstract class DeclutterRepo {
  Future<Either<Failure, Item>> addItem(Item item);

  Future<Either<Failure, Room>> addRoom(Room room);

  Future<Either<Failure, List<Room>>> getRooms();
}
