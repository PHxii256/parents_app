import 'package:get_it/get_it.dart';
import 'package:parent_app/features/absence/data/api_service.dart';

import 'absence_cubit.dart';
import 'absence_repo.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  //pass real api service
  sl.registerLazySingleton<FakeApiService>(() => FakeApiService());

  sl.registerLazySingleton<AbsenceRepository>(() => AbsenceRepository(sl()));

  sl.registerFactory(() => AbsenceCubit(sl()));
}
