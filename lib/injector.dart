import 'package:broom/data/datasources/local_datasource.dart';
import 'package:broom/data/repositories/declutter_repo_impl.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/domain/usecases/add_item.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:broom/presentation/bloc/camera_bloc.dart';
import 'package:broom/presentation/bloc/items_bloc.dart';
import 'package:broom/presentation/bloc/rooms_bloc.dart';
import 'package:get_it/get_it.dart';

import 'device/camera.dart';
import 'domain/usecases/add_room.dart';
import 'domain/usecases/get_rooms.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Datasource
  injector.registerSingleton<LocalDatasource>(
    await LocalDatasourceImpl.create(),
  );

  // Device
  injector.registerSingleton<Camera>(
    await Camera.create(),
  );

  // Usecases
  injector.registerLazySingleton(() => GetItems(injector()));
  injector.registerLazySingleton(() => AddItem(injector()));
  injector.registerLazySingleton(() => GetRooms(injector()));
  injector.registerLazySingleton(() => AddRoom(injector()));

  // Repository
  injector.registerLazySingleton<DeclutterRepo>(
    () => DeclutterRepoImpl(localDatasource: injector()),
  );

  // Blocs
  injector.registerFactory(
    () => ItemsBloc(injector(), injector()),
  );

  injector.registerFactory(
    () => CameraBloc(injector()),
  );

  injector.registerFactory(
    () => RoomsBloc(injector(), injector()),
  );
}
