import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/forecast_entity.dart';
import '../../../../core/utils/weather_utils.dart';

class DailyForecastList extends StatelessWidget {
  final List<ForecastEntity> forecast;
  const DailyForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecast.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final day = forecast[index];
              final isToday = index == 0;
              return _DailyItem(day: day, isToday: isToday);
            },
          ),
        ),
      ],
    );
  }
}

class _DailyItem extends StatelessWidget {
  final ForecastEntity day;
  final bool isToday;

  const _DailyItem({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 48,
            child: Text(
              isToday ? 'Today' : WeatherUtils.formatShortDay(day.date),
              style: TextStyle(
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),

          // Rain chance
          if (day.chanceOfRain > 0) ...[
            const SizedBox(width: 8),
            const Icon(Icons.water_drop, size: 14, color: Colors.blue),
            const SizedBox(width: 2),
            Text(
              '${day.chanceOfRain.round()}%',
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],

          const Spacer(),

          // Icon
          CachedNetworkImage(
            imageUrl: WeatherUtils.getWeatherIconUrl(day.conditionIcon),
            width: 32,
            height: 32,
            errorWidget: (_, __, ___) => const Icon(Icons.cloud, size: 24),
          ),
          const SizedBox(width: 12),

          // Temp range
          Text(
            WeatherUtils.formatTemp(day.minTempC),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            WeatherUtils.formatTemp(day.maxTempC),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
