import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;
  final double tempC;
  final double tempF;
  final double feelsLikeC;
  final double feelsLikeF;
  final int humidity;
  final double windKph;
  final double windMph;
  final int windDegree;
  final double visibilityKm;
  final double pressureMb;
  final double uvIndex;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final DateTime lastUpdated;

  const WeatherEntity({
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

  @override
  List<Object?> get props => [
        cityName,
        country,
        latitude,
        longitude,
        tempC,
        tempF,
        feelsLikeC,
        feelsLikeF,
        humidity,
        windKph,
        windMph,
        windDegree,
        visibilityKm,
        pressureMb,
        uvIndex,
        conditionText,
        conditionIcon,
        conditionCode,
        lastUpdated,
      ];
}
