import 'app_config.dart';
import 'app_environment.dart';

class FeatureFlags {
  static bool get insightPage => AppConfig.env == AppEnvironment.dev;
}
