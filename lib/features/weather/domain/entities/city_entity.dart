import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  const CityEntity({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get fullName => region.isNotEmpty ? '$name, $region, $country' : '$name, $country';

  @override
  List<Object?> get props => [name, region, country, latitude, longitude];
}
