import 'package:hive/hive.dart';
import '../../domain/entities/city_entity.dart';

part 'city_model.g.dart';

@HiveType(typeId: 3)
class CityModel extends HiveObject {
  @HiveField(0) final String name;
  @HiveField(1) final String region;
  @HiveField(2) final String country;
  @HiveField(3) final double latitude;
  @HiveField(4) final double longitude;

  CityModel({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json['name'] as String,
        region: json['region'] as String? ?? '',
        country: json['country'] as String,
        latitude: (json['lat'] as num).toDouble(),
        longitude: (json['lon'] as num).toDouble(),
      );

  factory CityModel.fromEntity(CityEntity entity) => CityModel(
        name: entity.name,
        region: entity.region,
        country: entity.country,
        latitude: entity.latitude,
        longitude: entity.longitude,
      );

  CityEntity toEntity() => CityEntity(
        name: name,
        region: region,
        country: country,
        latitude: latitude,
        longitude: longitude,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'region': region,
        'country': country,
        'lat': latitude,
        'lon': longitude,
      };
}
