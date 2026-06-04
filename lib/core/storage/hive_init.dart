import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../features/weather/data/models/weather_model.dart';
import '../../features/weather/data/models/forecast_model.dart';
import '../../features/weather/data/models/city_model.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(WeatherModelAdapter());
    Hive.registerAdapter(HourlyForecastModelAdapter());
    Hive.registerAdapter(ForecastModelAdapter());
    Hive.registerAdapter(CityModelAdapter());

    // Open boxes
    await Future.wait([
      Hive.openBox<WeatherModel>(AppConstants.weatherBox),
      Hive.openBox<ForecastModel>(AppConstants.forecastBox),
      Hive.openBox<CityModel>(AppConstants.favoritesBox),
      Hive.openBox<dynamic>(AppConstants.settingsBox),
    ]);
  }
}
