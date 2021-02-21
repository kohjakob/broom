import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatasource {
  Future<ItemModel> saveItemToDatabase(Item item);

  Future<List<ItemModel>> getItemsFromDatabase();
}

class LocalDatasourceImpl implements LocalDatasource {
  final String itemTable = 'items';
  final String itemId = 'id';
  final String itemName = 'name';
  final String itemDescription = 'description';
  final String createItemsTable =
      'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT, description TEXT);';
  final String clearItemsTable = 'DELETE FROM items;';
  Database db;
  final dbName = 'broom.db';
  final dbVersion = 15;

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
      },
      onUpgrade: (Database db, int version, int oldVersion) async {
        await db.execute(clearItemsTable);
      },
    );
  }

  @override
  Future<ItemModel> saveItemToDatabase(Item item) async {
    final itemModelMap = {
      itemName: item.name,
      itemDescription: item.description,
    };
    final insertedId = await db.insert(itemTable, itemModelMap);
    return ItemModel(
        name: item.name, description: item.description, id: insertedId);
  }

  @override
  Future<List<ItemModel>> getItemsFromDatabase() async {
    List<Map> itemModelMaps = await db.query(
      itemTable,
      columns: [itemId, itemName, itemDescription],
    );

    if (itemModelMaps.length > 0) {
      List<ItemModel> models = [];
      itemModelMaps.forEach((itemModelMap) {
        models.add(ItemModel(
          id: itemModelMap[itemId],
          name: itemModelMap[itemName],
          description: itemModelMap[itemDescription],
        ));
      });
      return models;
    } else {
      throw NoItemsYetException();
    }
  }
}
