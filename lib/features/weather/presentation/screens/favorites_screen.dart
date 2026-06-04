import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../providers/weather_notifier.dart';
import '../../domain/entities/city_entity.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cities')),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No favorites yet', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Search for a city and tap ♡ to save it.',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (_, i) => _FavoriteCityCard(city: favorites[i]),
            ),
    );
  }
}

class _FavoriteCityCard extends ConsumerWidget {
  final CityEntity city;
  const _FavoriteCityCard({required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.location_city,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(city.region.isNotEmpty
            ? '${city.region}, ${city.country}'
            : city.country),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => ref.read(favoritesProvider.notifier).removeFavorite(city.name),
        ),
        onTap: () {
          ref.read(weatherNotifierProvider.notifier).loadWeather(city.name);
          Navigator.pop(context);
        },
      ),
    );
  }
}
