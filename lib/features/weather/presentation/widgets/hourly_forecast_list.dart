import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../../../core/utils/weather_utils.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecastEntity> hourly;
  const HourlyForecastList({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    // Show next 24 hours only
    final next24 = hourly.take(24).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Hourly Forecast',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: next24.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = next24[index];
              final isNow = index == 0;
              return _HourlyItem(item: item, isNow: isNow);
            },
          ),
        ),
      ],
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final HourlyForecastEntity item;
  final bool isNow;

  const _HourlyItem({required this.item, required this.isNow});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNow
              ? Colors.transparent
              : colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isNow ? 'Now' : WeatherUtils.formatTime(item.time),
            style: TextStyle(
              fontSize: 11,
              color: isNow
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isNow ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          CachedNetworkImage(
            imageUrl: WeatherUtils.getWeatherIconUrl(item.conditionIcon),
            width: 32,
            height: 32,
            errorWidget: (_, __, ___) => Icon(Icons.cloud, size: 24,
                color: isNow ? colorScheme.onPrimary : null),
          ),
          Text(
            WeatherUtils.formatTemp(item.tempC),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isNow ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
