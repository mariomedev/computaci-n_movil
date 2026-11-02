import 'package:computacion_movil/core/di/network_injection.dart';
import 'package:computacion_movil/features/auth/di/auth_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Network
  await initNetworkDependencies(sl);

  // 2. Auth
  await initAuthDependencies(sl);
}
