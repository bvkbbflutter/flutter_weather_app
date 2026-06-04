import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/errors/either.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/usecases/weather_usecases.dart';
import '../../domain/entities/forecast_entity.dart';
import 'weather_state.dart';
import 'weather_providers.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeather;
  final GetWeatherByCoordinatesUseCase _getWeatherByCoordinates;
  final GetForecastUseCase _getForecast;
  final LocationService _locationService;

  WeatherNotifier({
    required GetCurrentWeatherUseCase getCurrentWeather,
    required GetWeatherByCoordinatesUseCase getWeatherByCoordinates,
    required GetForecastUseCase getForecast,
    required LocationService locationService,
  }) : _getCurrentWeather = getCurrentWeather,
       _getWeatherByCoordinates = getWeatherByCoordinates,
       _getForecast = getForecast,
       _locationService = locationService,
       super(const WeatherInitial());

  Future<void> loadWeather(String city) async {
    state = const WeatherLoading();

    final weatherResult = await _getCurrentWeather(city);
    final forecastResult = await _getForecast(city);

    if (weatherResult.isLeft) {
      final failure = weatherResult.left;
      if (failure is CacheFailure) {
        state = const WeatherOfflineEmpty();
      } else {
        state = WeatherError(_failureMessage(failure));
      }
      return;
    }

    final weather = weatherResult.right;
    final List<ForecastEntity> forecast = forecastResult.isRight
        ? forecastResult.right
        : [];
    final isFromCache = weatherResult is Right && forecastResult is Left;

    state = WeatherLoaded(
      weather: weather,
      forecast: forecast,
      isFromCache: isFromCache,
    );
  }

  Future<void> loadCurrentLocationWeather() async {
    state = const WeatherLoading();
    try {
      final position = await _locationService.getCurrentPosition();
      final weatherResult = await _getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      final city = weatherResult.isRight ? weatherResult.right.cityName : '';
      final forecastResult = city.isNotEmpty ? await _getForecast(city) : null;

      if (weatherResult.isLeft) {
        state = WeatherError(_failureMessage(weatherResult.left));
        return;
      }

      final weather = weatherResult.right;
      final forecast = (forecastResult != null && forecastResult.isRight)
          ? forecastResult.right
          : <ForecastEntity>[];

      state = WeatherLoaded(weather: weather, forecast: forecast);
    } on LocationException catch (e) {
      state = WeatherError(e.message);
    } catch (e) {
      state = WeatherError('Failed to get location: $e');
    }
  }

  Future<void> refreshWeather() async {
    final current = state;
    if (current is WeatherLoaded) {
      await loadWeather(current.weather.cityName);
    }
  }

  // String _failureMessage(Failure failure) {
  //   return switch (failure) {
  //     NetworkFailure() => 'No internet connection. Showing cached data.',
  //     ServerFailure() => 'Server error: ${failure.message}',
  //     CacheFailure() => 'No data available. Please connect to the internet.',
  //     LocationFailure() => 'Location error: ${failure.message}',
  //     UnknownFailure() => 'Unexpected error occurred.',
  //   };
  // }
  String _failureMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'No internet connection. Showing cached data.',
      ServerFailure() => 'Server error: ${failure.message}',
      CacheFailure() => 'No data available. Please connect to the internet.',
      LocationFailure() => 'Location error: ${failure.message}',
      UnknownFailure() => 'Unexpected error occurred.',
      _ => 'Unknown error occurred.', // Wildcard pattern
    };
  }
}

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
      return WeatherNotifier(
        getCurrentWeather: ref.watch(getCurrentWeatherUseCaseProvider),
        getWeatherByCoordinates: ref.watch(
          getWeatherByCoordinatesUseCaseProvider,
        ),
        getForecast: ref.watch(getForecastUseCaseProvider),
        locationService: ref.watch(locationServiceProvider),
      );
    });
