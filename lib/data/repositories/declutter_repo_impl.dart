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
}
