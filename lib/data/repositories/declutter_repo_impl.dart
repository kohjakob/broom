import 'package:broom/data/models/question_model.dart';
import 'package:broom/domain/entities/play_pile.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../core/errorhandling/exceptions.dart';
import '../../core/errorhandling/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/declutter_repo.dart';
import '../datasources/local_datasource.dart';

class DeclutterRepoImpl implements DeclutterRepo {
  final LocalDatasource localDatasource;

  DeclutterRepoImpl({
    @required this.localDatasource,
  });

  @override
  Future<Either<Failure, Item>> addItem(Item item) async {
    try {
      final savedItem = await localDatasource.saveItemToDatabase(item);
      return Right(savedItem);
    } on ItemSaveFailException {
      return Left(Failure(Code.ItemSaveFail));
    }
  }

  @override
  Future<Either<Failure, Room>> addRoom(Room room) async {
    try {
      final savedRoom = await localDatasource.saveRoomToDatabase(room);
      return Right(savedRoom);
    } on ItemSaveFailException {
      return Left(Failure(Code.RoomSaveFail));
    }
  }

  @override
  Future<Either<Failure, List<Room>>> getRooms() async {
    final rooms = await localDatasource.getRoomsFromDatabase();
    return Right(rooms);
  }

  @override
  Future<Either<Failure, Room>> editRoom(Room room) async {
    try {
      final updatedRoom = await localDatasource.editRoomInDatabase(room);
      return Right(updatedRoom);
    } on EditRoomFailedException {
      return Left(Failure(Code.RoomEditFail));
    }
  }

  @override
  Future<Either<Failure, Item>> editItem(Item item) async {
    try {
      final updatedItem = await localDatasource.editItemInDatabase(item);
      return Right(updatedItem);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(int id) async {
    try {
      final success = await localDatasource.deleteItemFromDatabase(id);
      return Right(success);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRoom(int id, bool keepItems) async {
    try {
      final success =
          await localDatasource.deleteRoomFromDatabase(id, keepItems);
      return Right(success);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final success = await localDatasource.getItemsFromDatabase();
      return Right(success);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }

  @override
  Future<Either<Failure, Question>> getRandomQuestion() async {
    try {
      List<QuestionModel> questions =
          await localDatasource.getQuestionsFromDatabase();
      questions.shuffle();
      return Right(questions.first);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getUnansweredItems(int questionId) async {
    try {
      List<Item> items = await localDatasource.getUnansweredItems(questionId);
      return Right(items);
    } on EditItemFailedException {
      return Left(Failure(Code.ItemEditFail));
    }
  }
}
