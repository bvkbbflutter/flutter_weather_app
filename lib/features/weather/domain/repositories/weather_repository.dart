import '../../../../core/errors/either.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather_entity.dart';
import '../entities/forecast_entity.dart';
import '../entities/city_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city);
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates(double lat, double lon);
  Future<Either<Failure, List<ForecastEntity>>> getForecast(String city, {int days = 7});
  Future<Either<Failure, List<CityEntity>>> searchCity(String query);
}
