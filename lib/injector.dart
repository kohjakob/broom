import 'package:broom/data/datasources/local_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final injector = GetIt.instance;

void init() async {
  // Setup hive boxes
  await Hive.initFlutter();
  final items = await Hive.openBox('items');
  final questions = await Hive.openBox('quesitons');
  injector.registerSingleton<LocalDatasource>(
    LocalDatasourceImpl(items, questions),
  );

  //! Core

  //! External
}
