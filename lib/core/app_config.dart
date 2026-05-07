import 'app_environment.dart';

class AppConfig {
  static AppEnvironment _env = AppEnvironment.prod;

  static void initialize({required AppEnvironment environment}) {
    _env = environment;
  }

  static AppEnvironment get env => _env;
}
