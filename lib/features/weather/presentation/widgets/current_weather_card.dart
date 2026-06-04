import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../../../core/utils/weather_utils.dart';
import '../providers/favorites_provider.dart';

class CurrentWeatherCard extends ConsumerWidget {
  final WeatherEntity weather;
  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFav = ref.watch(favoritesProvider.notifier).isFavorite(weather.cityName);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.8),
            colorScheme.secondary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City + Favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      weather.country,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red[300] : colorScheme.onPrimary,
                ),
                onPressed: () {
                  if (isFav) {
                    ref.read(favoritesProvider.notifier).removeFavorite(weather.cityName);
                  } else {
                    final city = CityEntity(
                      name: weather.cityName,
                      region: '',
                      country: weather.country,
                      latitude: weather.latitude,
                      longitude: weather.longitude,
                    );
                    ref.read(favoritesProvider.notifier).addFavorite(city);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WeatherUtils.formatTemp(weather.tempC),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  color: colorScheme.onPrimary,
                  height: 1,
                ),
              ),
              CachedNetworkImage(
                imageUrl: WeatherUtils.getWeatherIconUrl(weather.conditionIcon),
                width: 80,
                height: 80,
                errorWidget: (_, __, ___) =>
                    Icon(Icons.cloud, size: 64, color: colorScheme.onPrimary),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            weather.conditionText,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Feels like ${WeatherUtils.formatTemp(weather.feelsLikeC)}',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimary.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 16),
          Divider(color: colorScheme.onPrimary.withOpacity(0.2)),
          const SizedBox(height: 8),

          Text(
            'Last updated: ${WeatherUtils.formatTime(weather.lastUpdated)}',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onPrimary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
