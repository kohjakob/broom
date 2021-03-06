import 'package:broom/domain/usecases/delete_item.dart';
import 'package:broom/domain/usecases/edit_item.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:broom/presentation/bloc/item_detail_cubit.dart';
import 'package:broom/presentation/bloc/room_detail_cubit.dart';
import 'package:broom/presentation/bloc/swipe_cubit.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/local_datasource.dart';
import 'data/repositories/declutter_repo_impl.dart';
import 'domain/repositories/declutter_repo.dart';
import 'domain/usecases/add_item.dart';
import 'domain/usecases/add_room.dart';
import 'domain/usecases/delete_room.dart';
import 'domain/usecases/edit_room.dart';
import 'domain/usecases/get_rooms.dart';
import 'presentation/bloc/grid_cubit.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Datasource
  injector.registerSingleton<LocalDatasource>(
    await LocalDatasourceImpl.create(),
  );

  // Usecases
  injector.registerLazySingleton(() => AddItem(injector()));
  injector.registerLazySingleton(() => GetRooms(injector()));
  injector.registerLazySingleton(() => AddRoom(injector()));
  injector.registerLazySingleton(() => EditRoom(injector()));
  injector.registerLazySingleton(() => EditItem(injector()));
  injector.registerLazySingleton(() => DeleteItem(injector()));
  injector.registerLazySingleton(() => DeleteRoom(injector()));
  injector.registerLazySingleton(() => GetItems(injector()));

  // Repository
  injector.registerLazySingleton<DeclutterRepo>(
    () => DeclutterRepoImpl(localDatasource: injector()),
  );

  // Blocs
  injector.registerFactory(
    () => GridCubit(injector(), injector(), injector(), injector(), injector(),
        injector(), injector()),
  );

  injector.registerFactory(
    () => ItemDetailCubit(),
  );

  injector.registerFactory(
    () => RoomDetailCubit(),
  );

  injector.registerFactory(
    () => SwipeCubit(injector()),
  );
}
