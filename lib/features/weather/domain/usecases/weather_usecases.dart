import '../../../../core/errors/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather_entity.dart';
import '../entities/forecast_entity.dart';
import '../entities/city_entity.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository repository;
  GetCurrentWeatherUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call(String city) =>
      repository.getCurrentWeather(city);
}

class GetWeatherByCoordinatesUseCase {
  final WeatherRepository repository;
  GetWeatherByCoordinatesUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call(double lat, double lon) =>
      repository.getWeatherByCoordinates(lat, lon);
}

class GetForecastUseCase {
  final WeatherRepository repository;
  GetForecastUseCase(this.repository);

  Future<Either<Failure, List<ForecastEntity>>> call(String city, {int days = 7}) =>
      repository.getForecast(city, days: days);
}

class SearchCityUseCase {
  final WeatherRepository repository;
  SearchCityUseCase(this.repository);

  Future<Either<Failure, List<CityEntity>>> call(String query) =>
      repository.searchCity(query);
}
