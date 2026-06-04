import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../../../../core/utils/weather_utils.dart';

class WeatherStatsRow extends StatelessWidget {
  final WeatherEntity weather;
  const WeatherStatsRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _StatCard(
          icon: Icons.water_drop_outlined,
          label: 'Humidity',
          value: '${weather.humidity}%',
          color: Colors.blue,
        ),
        _StatCard(
          icon: Icons.air,
          label: 'Wind',
          value: '${weather.windKph.round()} km/h ${WeatherUtils.windDirection(weather.windDegree)}',
          color: Colors.cyan,
        ),
        _StatCard(
          icon: Icons.visibility_outlined,
          label: 'Visibility',
          value: '${weather.visibilityKm.round()} km',
          color: Colors.teal,
        ),
        _StatCard(
          icon: Icons.compress,
          label: 'Pressure',
          value: '${weather.pressureMb.round()} mb',
          color: Colors.indigo,
        ),
        _StatCard(
          icon: Icons.wb_sunny_outlined,
          label: 'UV Index',
          value: '${weather.uvIndex.round()} – ${WeatherUtils.uvIndexDescription(weather.uvIndex)}',
          color: Colors.orange,
        ),
        _StatCard(
          icon: Icons.thermostat_outlined,
          label: 'Feels Like',
          value: WeatherUtils.formatTemp(weather.feelsLikeC),
          color: Colors.deepOrange,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
