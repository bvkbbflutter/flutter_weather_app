import '../../../../core/errors/either.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/local/weather_local_datasource.dart';
import '../datasources/remote/weather_remote_datasource.dart';
import '../models/city_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city) async {
    final isOnline = await connectivityService.isConnected;
    if (isOnline) {
      try {
        final model = await remoteDataSource.getCurrentWeather(city);
        await localDataSource.cacheCurrentWeather(model);
        await localDataSource.saveLastCity(city);
        return right(model.toEntity());
      } on NetworkException catch (e) {
        return left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return left(ServerFailure(e.message, statusCode: e.statusCode));
      } catch (e) {
        return left(UnknownFailure(e.toString()));
      }
    } else {
      return _getCachedWeather();
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates(
      double lat, double lon) async {
    final isOnline = await connectivityService.isConnected;
    if (isOnline) {
      try {
        final model = await remoteDataSource.getWeatherByCoordinates(lat, lon);
        await localDataSource.cacheCurrentWeather(model);
        await localDataSource.saveLastCity(model.cityName);
        return right(model.toEntity());
      } on NetworkException catch (e) {
        return left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return left(ServerFailure(e.message, statusCode: e.statusCode));
      } catch (e) {
        return left(UnknownFailure(e.toString()));
      }
    } else {
      return _getCachedWeather();
    }
  }

  @override
  Future<Either<Failure, List<ForecastEntity>>> getForecast(
      String city, {int days = 7}) async {
    final isOnline = await connectivityService.isConnected;
    if (isOnline) {
      try {
        final models = await remoteDataSource.getForecast(city, days: days);
        await localDataSource.cacheForecast(models);
        return right(models.map((m) => m.toEntity()).toList());
      } on NetworkException catch (e) {
        return left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return left(ServerFailure(e.message, statusCode: e.statusCode));
      } catch (e) {
        return left(UnknownFailure(e.toString()));
      }
    } else {
      return _getCachedForecast();
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> searchCity(String query) async {
    final isOnline = await connectivityService.isConnected;
    if (!isOnline) {
      return left(const NetworkFailure('Search requires an internet connection.'));
    }
    try {
      final models = await remoteDataSource.searchCity(query);
      return right(models.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      return left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, WeatherEntity>> _getCachedWeather() async {
    try {
      final cached = await localDataSource.getCachedCurrentWeather();
      return right(cached.toEntity());
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, List<ForecastEntity>>> _getCachedForecast() async {
    try {
      final cached = await localDataSource.getCachedForecast();
      return right(cached.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }

  Future<Either<Failure, List<CityEntity>>> getFavoriteCities() async {
    try {
      final cities = await localDataSource.getFavoriteCities();
      return right(cities.map((c) => c.toEntity()).toList());
    } catch (e) {
      return left(CacheFailure('Failed to load favorites.'));
    }
  }

  Future<Either<Failure, void>> saveFavoriteCity(CityEntity city) async {
    try {
      await localDataSource.saveFavoriteCity(CityModel.fromEntity(city));
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to save city.'));
    }
  }

  Future<Either<Failure, void>> removeFavoriteCity(String cityName) async {
    try {
      await localDataSource.removeFavoriteCity(cityName);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to remove city.'));
    }
  }
}
