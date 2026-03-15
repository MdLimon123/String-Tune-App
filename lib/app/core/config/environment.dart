enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _current = Environment.dev;

  static Environment get current => _current;

  static void init(Environment env) => _current = env;

  static String get baseUrl {
    switch (_current) {
      case Environment.dev:
        return 'https://unhieratic-aurore-nonanatomically.ngrok-free.dev/api/v1';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }

  static bool get isDev => _current == Environment.dev;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProd => _current == Environment.prod;
}
