import 'package:client_app_example/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// The singleton instance of GetIt
final GetIt getIt = GetIt.instance; // default value is GetIt.instance,

@InjectableInit(
  // the default name for the initializer is 'init'
  // initializerName: 'init', default value is 'init'
  // controls how imports are written in the generated file
  preferRelativeImports: true, 
  // controls how the generated init API looks,
  // extension on GetIt vs a top-level function.
  // asExtension: true, // default value is false
)
/// The function to configure the dependencies
/// It is called in the main.dart file
Future<void> configureDependencies() async => getIt.init();
