import 'package:get_it/get_it.dart';

import 'data/datasources/local_datasource.dart';
import 'data/repositories/declutter_repo_impl.dart';
import 'device/camera.dart';
import 'domain/repositories/declutter_repo.dart';
import 'domain/usecases/add_item.dart';
import 'domain/usecases/add_room.dart';
import 'domain/usecases/edit_room.dart';
import 'domain/usecases/get_rooms.dart';
import 'presentation/bloc/camera_cubit.dart';
import 'presentation/bloc/grid_cubit.dart';

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
  injector.registerLazySingleton(() => AddItem(injector()));
  injector.registerLazySingleton(() => GetRooms(injector()));
  injector.registerLazySingleton(() => AddRoom(injector()));
  injector.registerLazySingleton(() => EditRoom(injector()));

  // Repository
  injector.registerLazySingleton<DeclutterRepo>(
    () => DeclutterRepoImpl(localDatasource: injector()),
  );

  // Blocs
  injector.registerFactory(
    () => GridCubit(injector(), injector(), injector(), injector()),
  );

  injector.registerFactory(
    () => CameraCubit(injector()),
  );
}
