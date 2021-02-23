import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:broom/data/models/room_model.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatasource {
  Future<ItemModel> saveItemToDatabase(Item item);

  Future<List<ItemModel>> getItemsFromDatabase();

  Future<RoomModel> saveRoomToDatabase(Room room);

  Future<List<RoomModel>> getRoomsFromDatabase();
}

class LocalDatasourceImpl implements LocalDatasource {
  final String itemTable = 'items';
  final String itemId = 'id';
  final String itemName = 'name';
  final String itemDescription = 'description';
  final String itemImagePath = 'imagePath';
  final String createItemsTable =
      'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT, description TEXT, imagePath TEXT);';
  final String clearItemsTable = 'DELETE FROM items;';

  final String roomTable = 'rooms';
  final String roomId = 'id';
  final String roomName = 'name';
  final String roomDescription = 'description';
  final String roomColor = 'color';
  final String createRoomsTable =
      'CREATE TABLE rooms (id INTEGER PRIMARY KEY, name TEXT, description TEXT, color TEXT);';
  final String clearRoomsTable = 'DELETE FROM rooms;';

  Database db;
  final dbName = 'broom.db';
  final dbVersion = 23;

  LocalDatasourceImpl._create();

  static Future<LocalDatasourceImpl> create() async {
    final datasource = LocalDatasourceImpl._create();
    await datasource.initDatabase();
    return datasource;
  }

  initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);
    db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute(createItemsTable);
        await db.execute(createRoomsTable);
      },
      onUpgrade: (Database db, int version, int oldVersion) async {
        await db.execute(clearItemsTable);
        await db.execute(clearRoomsTable);
      },
    );
  }

  @override
  Future<ItemModel> saveItemToDatabase(Item item) async {
    final itemModelMap = {
      itemName: item.name,
      itemDescription: item.description,
      itemImagePath: item.imagePath,
    };
    final insertedId = await db.insert(itemTable, itemModelMap);
    return ItemModel(
      name: item.name,
      description: item.description,
      id: insertedId,
      imagePath: item.imagePath,
    );
  }

  @override
  Future<List<ItemModel>> getItemsFromDatabase() async {
    List<Map> itemModelMaps = await db.query(
      itemTable,
      columns: [itemId, itemName, itemDescription, itemImagePath],
    );

    if (itemModelMaps.length > 0) {
      List<ItemModel> models = [];
      itemModelMaps.forEach((itemModelMap) {
        models.add(ItemModel(
          id: itemModelMap[itemId],
          name: itemModelMap[itemName],
          description: itemModelMap[itemDescription],
          imagePath: itemModelMap[itemImagePath],
        ));
      });
      return models;
    } else {
      throw NoItemsYetException();
    }
  }

  @override
  Future<RoomModel> saveRoomToDatabase(Room room) async {
    final roomModelMap = {
      roomName: room.name,
      roomDescription: room.description,
      roomColor: room.color,
    };
    final insertedId = await db.insert(roomTable, roomModelMap);
    return RoomModel(
      name: room.name,
      description: room.description,
      id: insertedId,
      color: room.color,
    );
  }

  @override
  Future<List<RoomModel>> getRoomsFromDatabase() async {
    List<Map> roomModelMaps = await db.query(
      roomTable,
      columns: [roomId, roomName, roomDescription, roomColor],
    );

    if (roomModelMaps.length > 0) {
      List<RoomModel> models = [];
      roomModelMaps.forEach((roomModelMap) {
        models.add(RoomModel(
          id: roomModelMap[roomId],
          name: roomModelMap[roomName],
          description: roomModelMap[roomDescription],
          color: roomModelMap[roomColor],
        ));
      });
      return models;
    } else {
      throw NoRoomsYetException();
    }
  }
}
