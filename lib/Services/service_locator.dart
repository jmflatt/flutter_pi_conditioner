import 'pi_conditioner_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<PiConditionerService>(() => PiConditionerService());
}