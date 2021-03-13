import 'package:broom/domain/entities/play_pile.dart';
import 'package:broom/domain/entities/question.dart';

import '../entities/room.dart';
import 'package:dartz/dartz.dart';
import '../../core/errorhandling/failures.dart';
import '../entities/item.dart';

abstract class DeclutterRepo {
  Future<Either<Failure, Item>> addItem(Item item);

  Future<Either<Failure, Item>> editItem(Item item);

  Future<Either<Failure, Room>> addRoom(Room room);

  Future<Either<Failure, Room>> editRoom(Room room);

  Future<Either<Failure, bool>> deleteItem(int id);

  Future<Either<Failure, bool>> deleteRoom(int id, bool keepItems);

  Future<Either<Failure, List<Room>>> getRooms();

  Future<Either<Failure, List<Item>>> getItems();

  Future<Either<Failure, List<Item>>> getUnansweredItems(int questionId);

  Future<Either<Failure, Question>> getRandomQuestion();
}
