import 'package:hive/hive.dart';
import '../../domain/entities/forecast_entity.dart';

part 'forecast_model.g.dart';

@HiveType(typeId: 1)
class HourlyForecastModel extends HiveObject {
  @HiveField(0) final DateTime time;
  @HiveField(1) final double tempC;
  @HiveField(2) final double tempF;
  @HiveField(3) final String conditionText;
  @HiveField(4) final String conditionIcon;
  @HiveField(5) final int conditionCode;
  @HiveField(6) final double chanceOfRain;

  HourlyForecastModel({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.chanceOfRain,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    final condition = json['condition'] as Map<String, dynamic>;
    return HourlyForecastModel(
      time: DateTime.parse(json['time'] as String),
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      conditionText: condition['text'] as String,
      conditionIcon: condition['icon'] as String,
      conditionCode: (condition['code'] as num).toInt(),
      chanceOfRain: (json['chance_of_rain'] as num).toDouble(),
    );
  }

  HourlyForecastEntity toEntity() => HourlyForecastEntity(
        time: time,
        tempC: tempC,
        tempF: tempF,
        conditionText: conditionText,
        conditionIcon: conditionIcon,
        conditionCode: conditionCode,
        chanceOfRain: chanceOfRain,
      );
}

@HiveType(typeId: 2)
class ForecastModel extends HiveObject {
  @HiveField(0) final DateTime date;
  @HiveField(1) final double maxTempC;
  @HiveField(2) final double minTempC;
  @HiveField(3) final double maxTempF;
  @HiveField(4) final double minTempF;
  @HiveField(5) final String conditionText;
  @HiveField(6) final String conditionIcon;
  @HiveField(7) final int conditionCode;
  @HiveField(8) final double chanceOfRain;
  @HiveField(9) final double uvIndex;
  @HiveField(10) final List<HourlyForecastModel> hourly;

  ForecastModel({
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

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final day = json['day'] as Map<String, dynamic>;
    final condition = day['condition'] as Map<String, dynamic>;
    final hourList = (json['hour'] as List<dynamic>)
        .map((h) => HourlyForecastModel.fromJson(h as Map<String, dynamic>))
        .toList();

    return ForecastModel(
      date: DateTime.parse(json['date'] as String),
      maxTempC: (day['maxtemp_c'] as num).toDouble(),
      minTempC: (day['mintemp_c'] as num).toDouble(),
      maxTempF: (day['maxtemp_f'] as num).toDouble(),
      minTempF: (day['mintemp_f'] as num).toDouble(),
      conditionText: condition['text'] as String,
      conditionIcon: condition['icon'] as String,
      conditionCode: (condition['code'] as num).toInt(),
      chanceOfRain: (day['daily_chance_of_rain'] as num).toDouble(),
      uvIndex: (day['uv'] as num).toDouble(),
      hourly: hourList,
    );
  }

  ForecastEntity toEntity() => ForecastEntity(
        date: date,
        maxTempC: maxTempC,
        minTempC: minTempC,
        maxTempF: maxTempF,
        minTempF: minTempF,
        conditionText: conditionText,
        conditionIcon: conditionIcon,
        conditionCode: conditionCode,
        chanceOfRain: chanceOfRain,
        uvIndex: uvIndex,
        hourly: hourly.map((h) => h.toEntity()).toList(),
      );
}
