import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/forecast_entity.dart';

sealed class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final List<ForecastEntity> forecast;
  final bool isFromCache;

  const WeatherLoaded({
    required this.weather,
    required this.forecast,
    this.isFromCache = false,
  });
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
}

class WeatherOfflineEmpty extends WeatherState {
  const WeatherOfflineEmpty();
}
