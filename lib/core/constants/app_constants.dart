class AppConstants {
  static const String appName = 'Weather App';
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
  static const int maxRetries = 3;

  // Hive Box Names
  static const String weatherBox = 'weather_box';
  static const String forecastBox = 'forecast_box';
  static const String favoritesBox = 'favorites_box';
  static const String settingsBox = 'settings_box';

  // Hive Keys
  static const String currentWeatherKey = 'current_weather';
  static const String hourlyForecastKey = 'hourly_forecast';
  static const String dailyForecastKey = 'daily_forecast';
  static const String themeModeKey = 'theme_mode';
  static const String lastCityKey = 'last_city';
  static const String favoriteCitiesKey = 'favorite_cities';

  // Hive TypeAdapter IDs
  static const int weatherModelAdapterId = 0;
  static const int hourlyForecastModelAdapterId = 1;
  static const int dailyForecastModelAdapterId = 2;
  static const int cityModelAdapterId = 3;
  static const int conditionModelAdapterId = 4;
}
