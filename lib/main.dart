import 'package:computacion_movil/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  AppConfig.validate();

  await Firebase.initializeApp();

  await initDependencies();

  final container = ProviderContainer();
  await container.read(themeNotifierProvider.notifier).init();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
