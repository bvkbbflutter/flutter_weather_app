import 'package:hive/hive.dart';
import '../../domain/entities/weather_entity.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0) final String cityName;
  @HiveField(1) final String country;
  @HiveField(2) final double latitude;
  @HiveField(3) final double longitude;
  @HiveField(4) final double tempC;
  @HiveField(5) final double tempF;
  @HiveField(6) final double feelsLikeC;
  @HiveField(7) final double feelsLikeF;
  @HiveField(8) final int humidity;
  @HiveField(9) final double windKph;
  @HiveField(10) final double windMph;
  @HiveField(11) final int windDegree;
  @HiveField(12) final double visibilityKm;
  @HiveField(13) final double pressureMb;
  @HiveField(14) final double uvIndex;
  @HiveField(15) final String conditionText;
  @HiveField(16) final String conditionIcon;
  @HiveField(17) final int conditionCode;
  @HiveField(18) final DateTime lastUpdated;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.tempC,
    required this.tempF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.humidity,
    required this.windKph,
    required this.windMph,
    required this.windDegree,
    required this.visibilityKm,
    required this.pressureMb,
    required this.uvIndex,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final condition = current['condition'] as Map<String, dynamic>;

    return WeatherModel(
      cityName: location['name'] as String,
      country: location['country'] as String,
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lon'] as num).toDouble(),
      tempC: (current['temp_c'] as num).toDouble(),
      tempF: (current['temp_f'] as num).toDouble(),
      feelsLikeC: (current['feelslike_c'] as num).toDouble(),
      feelsLikeF: (current['feelslike_f'] as num).toDouble(),
      humidity: (current['humidity'] as num).toInt(),
      windKph: (current['wind_kph'] as num).toDouble(),
      windMph: (current['wind_mph'] as num).toDouble(),
      windDegree: (current['wind_degree'] as num).toInt(),
      visibilityKm: (current['vis_km'] as num).toDouble(),
      pressureMb: (current['pressure_mb'] as num).toDouble(),
      uvIndex: (current['uv'] as num).toDouble(),
      conditionText: condition['text'] as String,
      conditionIcon: condition['icon'] as String,
      conditionCode: (condition['code'] as num).toInt(),
      lastUpdated: DateTime.parse(current['last_updated'] as String),
    );
  }

  WeatherEntity toEntity() => WeatherEntity(
        cityName: cityName,
        country: country,
        latitude: latitude,
        longitude: longitude,
        tempC: tempC,
        tempF: tempF,
        feelsLikeC: feelsLikeC,
        feelsLikeF: feelsLikeF,
        humidity: humidity,
        windKph: windKph,
        windMph: windMph,
        windDegree: windDegree,
        visibilityKm: visibilityKm,
        pressureMb: pressureMb,
        uvIndex: uvIndex,
        conditionText: conditionText,
        conditionIcon: conditionIcon,
        conditionCode: conditionCode,
        lastUpdated: lastUpdated,
      );
}
