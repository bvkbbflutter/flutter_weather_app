import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/location_service.dart';
import '../../data/datasources/local/weather_local_datasource.dart';
import '../../data/datasources/remote/weather_remote_datasource.dart';
import '../../data/models/city_model.dart';
import '../../data/models/forecast_model.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/weather_usecases.dart';

// ─── Infrastructure ────────────────────────────────────────────────────────────

final connectivityProvider = StreamProvider<bool>((ref) {
  final service = ConnectivityService();
  return service.onConnectivityChanged.asyncMap((_) => service.isConnected);
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService(connectivity: Connectivity());
});

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

// ─── Hive Boxes ───────────────────────────────────────────────────────────────

final weatherBoxProvider = Provider<Box<WeatherModel>>((ref) {
  return Hive.box<WeatherModel>(AppConstants.weatherBox);
});

final forecastBoxProvider = Provider<Box<ForecastModel>>((ref) {
  return Hive.box<ForecastModel>(AppConstants.forecastBox);
});

final favoritesBoxProvider = Provider<Box<CityModel>>((ref) {
  return Hive.box<CityModel>(AppConstants.favoritesBox);
});

final settingsBoxProvider = Provider<Box<dynamic>>((ref) {
  return Hive.box<dynamic>(AppConstants.settingsBox);
});

// ─── Data Layer ───────────────────────────────────────────────────────────────

final remoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  return WeatherRemoteDataSourceImpl();
});

final localDataSourceProvider = Provider<WeatherLocalDataSource>((ref) {
  return WeatherLocalDataSourceImpl(
    weatherBox: ref.watch(weatherBoxProvider),
    forecastBox: ref.watch(forecastBoxProvider),
    favoritesBox: ref.watch(favoritesBoxProvider),
    settingsBox: ref.watch(settingsBoxProvider),
  );
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

// (Also expose as Impl for favorites methods)
final weatherRepositoryImplProvider = Provider<WeatherRepositoryImpl>((ref) {
  return ref.watch(weatherRepositoryProvider) as WeatherRepositoryImpl;
});

// ─── Use Cases ────────────────────────────────────────────────────────────────

final getCurrentWeatherUseCaseProvider = Provider<GetCurrentWeatherUseCase>((
  ref,
) {
  return GetCurrentWeatherUseCase(ref.watch(weatherRepositoryProvider));
});

final getWeatherByCoordinatesUseCaseProvider =
    Provider<GetWeatherByCoordinatesUseCase>((ref) {
      return GetWeatherByCoordinatesUseCase(
        ref.watch(weatherRepositoryProvider),
      );
    });

final getForecastUseCaseProvider = Provider<GetForecastUseCase>((ref) {
  return GetForecastUseCase(ref.watch(weatherRepositoryProvider));
});

final searchCityUseCaseProvider = Provider<SearchCityUseCase>((ref) {
  return SearchCityUseCase(ref.watch(weatherRepositoryProvider));
});

// ─── Theme ────────────────────────────────────────────────────────────────────

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final WeatherLocalDataSource _local;

  ThemeNotifier(this._local) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _local.getSavedThemeMode();
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await _local.saveThemeMode(!isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(localDataSourceProvider));
});
