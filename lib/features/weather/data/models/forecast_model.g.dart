// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

class HourlyForecastModelAdapter extends TypeAdapter<HourlyForecastModel> {
  @override
  final int typeId = 1;

  @override
  HourlyForecastModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyForecastModel(
      time: fields[0] as DateTime,
      tempC: fields[1] as double,
      tempF: fields[2] as double,
      conditionText: fields[3] as String,
      conditionIcon: fields[4] as String,
      conditionCode: fields[5] as int,
      chanceOfRain: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HourlyForecastModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.tempC)
      ..writeByte(2)
      ..write(obj.tempF)
      ..writeByte(3)
      ..write(obj.conditionText)
      ..writeByte(4)
      ..write(obj.conditionIcon)
      ..writeByte(5)
      ..write(obj.conditionCode)
      ..writeByte(6)
      ..write(obj.chanceOfRain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyForecastModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForecastModelAdapter extends TypeAdapter<ForecastModel> {
  @override
  final int typeId = 2;

  @override
  ForecastModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastModel(
      date: fields[0] as DateTime,
      maxTempC: fields[1] as double,
      minTempC: fields[2] as double,
      maxTempF: fields[3] as double,
      minTempF: fields[4] as double,
      conditionText: fields[5] as String,
      conditionIcon: fields[6] as String,
      conditionCode: fields[7] as int,
      chanceOfRain: fields[8] as double,
      uvIndex: fields[9] as double,
      hourly: (fields[10] as List).cast<HourlyForecastModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ForecastModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.maxTempC)
      ..writeByte(2)
      ..write(obj.minTempC)
      ..writeByte(3)
      ..write(obj.maxTempF)
      ..writeByte(4)
      ..write(obj.minTempF)
      ..writeByte(5)
      ..write(obj.conditionText)
      ..writeByte(6)
      ..write(obj.conditionIcon)
      ..writeByte(7)
      ..write(obj.conditionCode)
      ..writeByte(8)
      ..write(obj.chanceOfRain)
      ..writeByte(9)
      ..write(obj.uvIndex)
      ..writeByte(10)
      ..write(obj.hourly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
