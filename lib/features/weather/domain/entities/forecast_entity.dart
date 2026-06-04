import 'package:equatable/equatable.dart';

class HourlyForecastEntity extends Equatable {
  final DateTime time;
  final double tempC;
  final double tempF;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double chanceOfRain;

  const HourlyForecastEntity({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.chanceOfRain,
  });

  @override
  List<Object?> get props =>
      [time, tempC, tempF, conditionText, conditionIcon, conditionCode, chanceOfRain];
}

class ForecastEntity extends Equatable {
  final DateTime date;
  final double maxTempC;
  final double minTempC;
  final double maxTempF;
  final double minTempF;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double chanceOfRain;
  final double uvIndex;
  final List<HourlyForecastEntity> hourly;

  const ForecastEntity({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.chanceOfRain,
    required this.uvIndex,
    required this.hourly,
  });

  @override
  List<Object?> get props => [
        date,
        maxTempC,
        minTempC,
        maxTempF,
        minTempF,
        conditionText,
        conditionIcon,
        conditionCode,
        chanceOfRain,
        uvIndex,
        hourly,
      ];
}
