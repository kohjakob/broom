import 'package:broom/data/models/item_model.dart';
import 'package:broom/domain/entities/item.dart';

abstract class LocalDatasource {
  Future<ItemModel> saveItemToDatabase(Item item);
}
