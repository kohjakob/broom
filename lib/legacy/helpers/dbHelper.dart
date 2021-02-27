import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE items(id TEXT PRIMARY KEY, title TEXT, description TEXT, imgPath TEXT)');
      await db
          .execute('CREATE TABLE answers(id TEXT, itemId TEXT, answer REAL)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> deleteItemAndItemAnswers(String itemId) async {
    final db = await DBHelper.database();
    db.delete("items", where: "id = ?", whereArgs: [itemId]);
    db.delete("answers", where: "itemId = ?", whereArgs: [itemId]);
  }
}
