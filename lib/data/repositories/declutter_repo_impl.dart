import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

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
    } on ItemSaveFailException {
      return Left(Failure(Code.RoomSaveFail));
    }
  }
}
