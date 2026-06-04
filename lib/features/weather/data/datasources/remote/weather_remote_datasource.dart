import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/city_model.dart';
import '../../models/forecast_model.dart';
import '../../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String city);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
  Future<List<ForecastModel>> getForecast(String city, {int days = 7});
  Future<List<CityModel>> searchCity(String query);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;

  WeatherRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      final response =
          await _dio.get('/current.json', queryParameters: {'q': city});
      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/current.json',
        queryParameters: {'q': '$lat,$lon'},
      );
      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<List<ForecastModel>> getForecast(String city, {int days = 7}) async {
    try {
      final response = await _dio.get(
        '/forecast.json',
        queryParameters: {'q': city, 'days': days, 'aqi': 'no', 'alerts': 'no'},
      );
      final forecastDay =
          (response.data['forecast']['forecastday'] as List<dynamic>);
      return forecastDay
          .map((d) => ForecastModel.fromJson(d as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<List<CityModel>> searchCity(String query) async {
    try {
      final response =
          await _dio.get('/search.json', queryParameters: {'q': query});
      final results = response.data as List<dynamic>;
      return results
          .map((r) => CityModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
