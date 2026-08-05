import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  // the default name for the initializer is 'init'
  initializerName: 'init',
  // controls how imports are written in the generated file
  preferRelativeImports: true,
  // controls how the generated init API looks,
  // extension on GetIt vs a top-level function.
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
