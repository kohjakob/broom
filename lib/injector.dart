import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/data/repositories/declutter_repo_impl.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/domain/usecases/add_item.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Datasource
  injector.registerSingleton<LocalDatasource>(
    await LocalDatasourceImpl.create(),
  );

  // Usecases
  injector.registerLazySingleton(() => GetItems(injector()));
  injector.registerLazySingleton(() => AddItem(injector()));

  // Repository
  injector.registerLazySingleton<DeclutterRepo>(
    () => DeclutterRepoImpl(localDatasource: injector()),
  );

  // Blocs
  injector.registerFactory(
    () => ItemsBloc(injector(), injector()),
  );
}
