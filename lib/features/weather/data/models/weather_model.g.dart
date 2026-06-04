// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written Hive TypeAdapters for WeatherModel

part of 'weather_model.dart';

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 0;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      cityName: fields[0] as String,
      country: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      tempC: fields[4] as double,
      tempF: fields[5] as double,
      feelsLikeC: fields[6] as double,
      feelsLikeF: fields[7] as double,
      humidity: fields[8] as int,
      windKph: fields[9] as double,
      windMph: fields[10] as double,
      windDegree: fields[11] as int,
      visibilityKm: fields[12] as double,
      pressureMb: fields[13] as double,
      uvIndex: fields[14] as double,
      conditionText: fields[15] as String,
      conditionIcon: fields[16] as String,
      conditionCode: fields[17] as int,
      lastUpdated: fields[18] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.cityName)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.tempC)
      ..writeByte(5)
      ..write(obj.tempF)
      ..writeByte(6)
      ..write(obj.feelsLikeC)
      ..writeByte(7)
      ..write(obj.feelsLikeF)
      ..writeByte(8)
      ..write(obj.humidity)
      ..writeByte(9)
      ..write(obj.windKph)
      ..writeByte(10)
      ..write(obj.windMph)
      ..writeByte(11)
      ..write(obj.windDegree)
      ..writeByte(12)
      ..write(obj.visibilityKm)
      ..writeByte(13)
      ..write(obj.pressureMb)
      ..writeByte(14)
      ..write(obj.uvIndex)
      ..writeByte(15)
      ..write(obj.conditionText)
      ..writeByte(16)
      ..write(obj.conditionIcon)
      ..writeByte(17)
      ..write(obj.conditionCode)
      ..writeByte(18)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
