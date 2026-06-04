import 'package:hive/hive.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/weather_model.dart';
import '../../models/forecast_model.dart';
import '../../models/city_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheCurrentWeather(WeatherModel weather);
  Future<void> cacheForecast(List<ForecastModel> forecast);
  Future<WeatherModel> getCachedCurrentWeather();
  Future<List<ForecastModel>> getCachedForecast();
  Future<void> clearWeatherCache();

  Future<void> saveFavoriteCity(CityModel city);
  Future<void> removeFavoriteCity(String cityName);
  Future<List<CityModel>> getFavoriteCities();

  Future<void> saveThemeMode(bool isDark);
  Future<bool> getSavedThemeMode();

  Future<void> saveLastCity(String cityName);
  Future<String?> getLastCity();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<WeatherModel> _weatherBox;
  final Box<ForecastModel> _forecastBox;
  final Box<CityModel> _favoritesBox;
  final Box<dynamic> _settingsBox;

  WeatherLocalDataSourceImpl({
    required Box<WeatherModel> weatherBox,
    required Box<ForecastModel> forecastBox,
    required Box<CityModel> favoritesBox,
    required Box<dynamic> settingsBox,
  })  : _weatherBox = weatherBox,
        _forecastBox = forecastBox,
        _favoritesBox = favoritesBox,
        _settingsBox = settingsBox;

  @override
  Future<void> cacheCurrentWeather(WeatherModel weather) async {
    await _weatherBox.put(AppConstants.currentWeatherKey, weather);
  }

  @override
  Future<WeatherModel> getCachedCurrentWeather() async {
    final weather = _weatherBox.get(AppConstants.currentWeatherKey);
    if (weather == null) {
      throw const CacheException('No cached weather data found.');
    }
    return weather;
  }

  @override
  Future<void> cacheForecast(List<ForecastModel> forecast) async {
    await _forecastBox.clear();
    for (var i = 0; i < forecast.length; i++) {
      await _forecastBox.put('${AppConstants.dailyForecastKey}_$i', forecast[i]);
    }
  }

  @override
  Future<List<ForecastModel>> getCachedForecast() async {
    final forecasts = _forecastBox.values.toList();
    if (forecasts.isEmpty) {
      throw const CacheException('No cached forecast data found.');
    }
    return forecasts;
  }

  @override
  Future<void> clearWeatherCache() async {
    await _weatherBox.clear();
    await _forecastBox.clear();
  }

  @override
  Future<void> saveFavoriteCity(CityModel city) async {
    await _favoritesBox.put(city.name, city);
  }

  @override
  Future<void> removeFavoriteCity(String cityName) async {
    await _favoritesBox.delete(cityName);
  }

  @override
  Future<List<CityModel>> getFavoriteCities() async {
    return _favoritesBox.values.toList();
  }

  @override
  Future<void> saveThemeMode(bool isDark) async {
    await _settingsBox.put(AppConstants.themeModeKey, isDark);
  }

  @override
  Future<bool> getSavedThemeMode() async {
    return _settingsBox.get(AppConstants.themeModeKey, defaultValue: false) as bool;
  }

  @override
  Future<void> saveLastCity(String cityName) async {
    await _settingsBox.put(AppConstants.lastCityKey, cityName);
  }

  @override
  Future<String?> getLastCity() async {
    return _settingsBox.get(AppConstants.lastCityKey) as String?;
  }
}
