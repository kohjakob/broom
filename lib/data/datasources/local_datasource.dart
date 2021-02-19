import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/data/models/item_model.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class LocalDatasource {
  Future<ItemModel> saveItemToDatabase(Item item);

  Future<List<ItemModel>> getItemsFromDatabase();
}

class LocalDatasourceImpl implements LocalDatasource {
  Box items;
  Box questions;
  bool isReady = false;

  LocalDatasourceImpl(this.items, this.questions);

  @override
  Future<ItemModel> saveItemToDatabase(Item item) async {
    final model = ItemModel(
      name: item.name,
      description: item.description,
      id: Uuid().v4(),
    );

    final key = await items.add(model);

    return items.get(key);
  }

  @override
  Future<List<ItemModel>> getItemsFromDatabase() async {
    if (items.isEmpty) {
      throw NoItemsYetException();
    } else {
      final models = items.values;
      return models;
    }
  }
}
