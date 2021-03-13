import 'package:broom/data/models/question_model.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:broom/domain/usecases/get_question_answers.dart';
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

  Future<bool> deleteItemFromDatabase(int id);

  Future<bool> deleteRoomFromDatabase(int id, bool keepItems);

  Future<List<RoomModel>> getRoomsFromDatabase();

  Future<List<ItemModel>> getItemsFromDatabase();

  Future<List<QuestionModel>> getQuestionsFromDatabase();

  Future<List<ItemModel>> getUnansweredItems(int questionId);

  Future<bool> answerQuestion(int questionId, int itemId, Answer answer);

  Future<Map<QuestionModel, Answer>> getQuestionAnswers(int itemId);
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

  final String questionTable = 'questions';
  final String questionId = 'id';
  final String questionText = 'text';
  final String questionAnswer = 'answer';
  final String questionCategory = 'category';

  final String answerTable = 'answers';
  final String answerQuestionId = 'questionId';
  final String answerItemId = 'itemId';
  final String answerDate = 'date';
  final String answerValue = 'answer';

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
        await db.execute(
            'CREATE TABLE $questionTable ($questionId INTEGER PRIMARY KEY, $questionText TEXT, $questionAnswer BOOLEAN, $questionCategory INTEGER);');
        await db.execute(
            'CREATE TABLE $answerTable ($answerQuestionId INTEGER, $answerItemId INTEGER, $answerDate DATE, $answerValue BOOLEAN);');

        final uncategorizedRoom = {
          roomName: "Other",
          roomDescription: "Items not associated to a room",
          roomId: -1,
          roomColor: CustomColor.LIGHTGRAY.index,
        };
        await db.insert(roomTable, uncategorizedRoom);

        final testQuestion = {
          questionText: "Does this add value to your life?",
          questionCategory: "VALUE",
          questionAnswer: 1,
        };
        await db.insert(questionTable, testQuestion);
        final testQuestion1 = {
          questionText: "Did you use this the past week?",
          questionCategory: "VALUE",
          questionAnswer: 1,
        };
        await db.insert(questionTable, testQuestion1);
        final testQuestion2 = {
          questionText: "Would you sell this if you get what you paid for it?",
          questionCategory: "VALUE",
          questionAnswer: 1,
        };
        await db.insert(questionTable, testQuestion2);
      },
      onUpgrade: (Database db, int version, int oldVersion) async {
        await db.execute('DELETE FROM $itemTable;');
        await db.execute('DELETE FROM $roomTable;');
        await db.execute('DELETE FROM $questionTable;');
        await db.execute('DELETE FROM $answerTable;');
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
      itemImagePath: item.imagePath,
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

  @override
  Future<bool> deleteItemFromDatabase(int id) async {
    final countDeletedItems =
        await db.delete(itemTable, where: "$itemId = ?", whereArgs: [id]);
    if (countDeletedItems > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> deleteRoomFromDatabase(int id, bool keepItems) async {
    if (keepItems) {
      final countDeletedRooms =
          await db.delete(roomTable, where: "$roomId = ?", whereArgs: [id]);
      await db.update(itemTable, {itemRoomId: -1},
          where: "$itemRoomId = ?", whereArgs: [id]);
      if (countDeletedRooms > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      final countDeletedRooms =
          await db.delete(roomTable, where: "$roomId = ?", whereArgs: [id]);
      await db.delete(itemTable, where: "$itemRoomId = ?", whereArgs: [id]);
      if (countDeletedRooms > 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<List<ItemModel>> getItemsFromDatabase() async {
    List<Map> itemsMap = await db.query(
      itemTable,
    );

    if (itemsMap.length > 0) {
      final items = itemsMap
          .map(
            (itemMap) => ItemModel(
              name: itemMap[itemName],
              description: itemMap[itemDescription],
              id: itemMap[itemId],
              imagePath: itemMap[itemImagePath],
              roomId: itemMap[itemRoomId],
            ),
          )
          .toList();

      return items;
    } else {
      return [];
    }
  }

  @override
  Future<List<QuestionModel>> getQuestionsFromDatabase() async {
    List<Map> questionsMap = await db.query(
      questionTable,
    );

    if (questionsMap.length > 0) {
      final questions = questionsMap
          .map(
            (questionMap) => QuestionModel(
              id: questionMap[questionId],
              category: questionMap[questionCategory],
              text: questionMap[questionText],
              answerIndicatingValue: questionMap[questionAnswer],
            ),
          )
          .toList();

      return questions;
    } else {
      return [];
    }
  }

  @override
  Future<List<ItemModel>> getUnansweredItems(int questionId) async {
    List<Map> answersMap = await db.query(
      answerTable,
      columns: ['$answerItemId'],
      where: "$answerQuestionId = ?",
      whereArgs: [questionId],
    );

    if (answersMap.length > 0) {
      final answeredQuestionIds =
          answersMap.map((answerMap) => answerMap[answerItemId]).toList();

      var selectUnansweredQuestions =
          'SELECT * FROM $itemTable  WHERE $itemId NOT IN (\'' +
              (answeredQuestionIds.join('\',\'')).toString() +
              '\')';
      final itemsMap = await db.rawQuery(selectUnansweredQuestions);

      if (itemsMap.length > 0) {
        final items = itemsMap
            .map(
              (itemMap) => ItemModel(
                name: itemMap[itemName],
                description: itemMap[itemDescription],
                id: itemMap[itemId],
                imagePath: itemMap[itemImagePath],
                roomId: itemMap[itemRoomId],
              ),
            )
            .toList();

        return items;
      }
      return [];
    } else {
      return await getItemsFromDatabase();
    }
  }

  @override
  Future<bool> answerQuestion(int questionId, int itemId, Answer answer) async {
    final now = DateTime.now().toString();
    final answerQuestion = {
      answerDate: now,
      answerItemId: itemId,
      answerQuestionId: questionId,
      answerValue: (answer == Answer.Yes) ? true : false,
    };
    final result = await db.insert(answerTable, answerQuestion);
    if (result > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Map<QuestionModel, Answer>> getQuestionAnswers(int itemId) async {
    final questions = await getQuestionsFromDatabase();
    List<Map> questionAnswersMap = await db.query(
      answerTable,
      where: '$answerItemId = ?',
      whereArgs: [itemId],
    );
    print(questionAnswersMap);
    if (questionAnswersMap.length > 0) {
      Map<QuestionModel, Answer> result = {};
      questionAnswersMap.forEach(
        (questionAnswerMap) {
          final answer =
              (questionAnswerMap[answerValue] == 1) ? Answer.Yes : Answer.No;
          result[questions.firstWhere((question) =>
              question.id == questionAnswerMap[answerQuestionId])] = answer;
        },
      );

      return result;
    }

    return {};
  }
}
