import 'package:get_it/get_it.dart';
import 'package:parent_app/features/absence/data/api_service.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';

import 'absence_cubit.dart';
import 'absence_repo.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<AbsenceApiService>(() => buildAbsenceApiService());

  sl.registerLazySingleton<AbsenceRepository>(() => AbsenceRepository(sl()));

  sl.registerLazySingleton<GuardianRepository>(() => GuardianRepository());

  sl.registerFactory(() => AbsenceCubit(sl(), guardianRepository: sl()));
}
