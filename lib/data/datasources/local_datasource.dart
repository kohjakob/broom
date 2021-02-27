import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/colors.dart';
import '../../core/errorhandling/exceptions.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/room.dart';
import '../models/item_model.dart';
import '../models/room_model.dart';

abstract class LocalDatasource {
  Future<ItemModel> saveItemToDatabase(Item item);

  Future<RoomModel> saveRoomToDatabase(Room room);

  Future<RoomModel> editRoomInDatabase(Room room);

  Future<ItemModel> editItemInDatabase(Item item);

  Future<List<RoomModel>> getRoomsFromDatabase();
}

class LocalDatasourceImpl implements LocalDatasource {
  final String itemTable = 'items';
  final String itemId = 'id';
  final String itemName = 'name';
  final String itemDescription = 'description';
  final String itemImagePath = 'imagePath';
  final String itemRoomId = "roomId";
  final String itemCreatedAt = "createdAt";

  final String roomTable = 'rooms';
  final String roomId = 'id';
  final String roomName = 'name';
  final String roomDescription = 'description';
  final String roomColor = 'color';

  Database db;
  final dbName = 'broom.db';
  final dbVersion = 29;

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
        await db.execute(
            'CREATE TABLE $itemTable ($itemId INTEGER PRIMARY KEY, $itemName TEXT, $itemDescription TEXT, $itemImagePath TEXT, $itemRoomId INTEGER, $itemCreatedAt DATE);');
        await db.execute(
            'CREATE TABLE $roomTable ($roomId INTEGER PRIMARY KEY, $roomName TEXT, $roomDescription TEXT, $roomColor TEXT);');

        final uncategorizedRoom = {
          roomName: "Other",
          roomDescription: "Items not associated to a room",
          roomId: -1,
          roomColor: CustomColor.LIGHTGRAY.index,
        };
        await db.insert(roomTable, uncategorizedRoom);
      },
      onUpgrade: (Database db, int version, int oldVersion) async {
        await db.execute('DELETE FROM $itemTable;');
        await db.execute('DELETE FROM $roomTable;');
      },
    );
  }

  @override
  Future<ItemModel> saveItemToDatabase(Item item) async {
    final now = DateTime.now().toString();
    final itemModelMap = {
      itemName: item.name,
      itemDescription: item.description,
      itemImagePath: item.imagePath,
      itemRoomId: item.roomId,
      itemCreatedAt: now,
    };

    final insertedId = await db.insert(itemTable, itemModelMap);

    return ItemModel(
      name: item.name,
      description: item.description,
      id: insertedId,
      imagePath: item.imagePath,
      roomId: item.roomId,
    );
  }

  @override
  Future<RoomModel> saveRoomToDatabase(Room room) async {
    final roomModelMap = {
      roomName: room.name,
      roomDescription: room.description,
      roomColor: room.color.index,
    };

    final insertedId = await db.insert(roomTable, roomModelMap);

    return RoomModel(
      name: room.name,
      description: room.description,
      id: insertedId,
      items: null,
      color: CustomColor.values[room.color.index],
    );
  }

  @override
  Future<List<RoomModel>> getRoomsFromDatabase() async {
    List<Map> roomMaps = await db.query(
      roomTable,
    );

    // If we find min 1 room
    if (roomMaps.length > 0) {
      List<RoomModel> rooms = [];

      // For each room
      for (Map roomMap in roomMaps) {
        // Look up items in this room
        List<Map> itemMaps = await db.query(
          itemTable,
          where: '$itemRoomId = ?',
          whereArgs: [roomMap[roomId]],
        );
        // Build ItemModel for every found row
        final items = itemMaps
            .map((itemMap) => ItemModel(
                  name: itemMap[itemName],
                  description: itemMap[itemDescription],
                  id: itemMap[itemId],
                  imagePath: itemMap[itemImagePath],
                  roomId: itemMap[itemRoomId],
                ))
            .toList();

        // Build RoomModel for every found row
        final colorFromIndex =
            CustomColor.values[int.parse(roomMap[roomColor])];
        rooms.add(
          RoomModel(
            id: roomMap[roomId],
            name: roomMap[roomName],
            description: roomMap[roomDescription],
            items: items,
            color: colorFromIndex,
          ),
        );
      }

      return rooms;
    } else {
      // Else the list of rooms is empty
      return [];
    }
  }

  @override
  Future<RoomModel> editRoomInDatabase(Room room) async {
    final roomModelMap = {
      roomName: room.name,
      roomDescription: room.description,
      roomColor: room.color.index,
    };

    int countUpdatedRooms = await db.update(roomTable, roomModelMap,
        where: "$roomId = ?", whereArgs: [room.id]);

    if (countUpdatedRooms > 0) {
      return RoomModel(
        name: room.name,
        description: room.description,
        color: room.color,
        id: room.id,
        items: room.items,
      );
    } else {
      throw EditRoomFailedException();
    }
  }

  @override
  Future<ItemModel> editItemInDatabase(Item item) async {
    final itemModelMap = {
      itemName: item.name,
      itemDescription: item.description,
      itemRoomId: item.roomId,
    };

    int countUpdatedItems = await db.update(itemTable, itemModelMap,
        where: "$itemId = ?", whereArgs: [item.id]);

    if (countUpdatedItems > 0) {
      return ItemModel(
        description: item.description,
        id: item.id,
        imagePath: item.imagePath,
        name: item.name,
        roomId: item.roomId,
      );
    } else {
      throw EditItemFailedException();
    }
  }
}
