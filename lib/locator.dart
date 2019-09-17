import 'package:carpool/core/services/all_service.dart';
import 'package:carpool/core/viewmodels/all_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton(() => Api())
    ..registerLazySingleton(() => TripService())
    ..registerLazySingleton(() => AuthenticationService())
    ..registerFactory(() => RootModel())
    ..registerFactory(() => RegisterModel())
    ..registerFactory(() => AccountTabModel())
    ..registerFactory(() => HistoryTabModel())
    ..registerFactory(() => PickDestinationModel())
    ..registerFactory(() => PickOriginModel())
    ..registerFactory(() => TripSummaryModel())
    ..registerFactory(() => OrderLaterModel())
    ..registerFactory(() => TripModel())
    ..registerFactory(() => EditProfileModel());
}
