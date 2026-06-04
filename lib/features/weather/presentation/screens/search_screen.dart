import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/weather_notifier.dart';
import '../providers/favorites_provider.dart';
import '../../domain/entities/city_entity.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  void _selectCity(CityEntity city) {
    ref.read(weatherNotifierProvider.notifier).loadWeather(city.name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for a city...',
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: switch (searchState) {
        SearchInitial() => _buildInitial(context),
        SearchLoading() => const Center(child: CircularProgressIndicator()),
        SearchError(:final message) => _buildError(message),
        SearchLoaded(:final results) => results.isEmpty
            ? _buildNoResults()
            : _buildResults(results),
      },
    );
  }

  Widget _buildInitial(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Type to search for a city', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Favorites',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (_, i) => _CityTile(
              city: favorites[i],
              onTap: () => _selectCity(favorites[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(List<CityEntity> results) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (_, i) => _CityTile(
          city: results[i],
          onTap: () => _selectCity(results[i]),
        ),
      );

  Widget _buildNoResults() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No cities found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );

  Widget _buildError(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      );
}

class _CityTile extends ConsumerWidget {
  final CityEntity city;
  final VoidCallback onTap;
  const _CityTile({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider.notifier).isFavorite(city.name);

    return ListTile(
      leading: const Icon(Icons.location_city_outlined),
      title: Text(city.name),
      subtitle: Text(city.region.isNotEmpty
          ? '${city.region}, ${city.country}'
          : city.country),
      trailing: IconButton(
        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : null),
        onPressed: () {
          if (isFav) {
            ref.read(favoritesProvider.notifier).removeFavorite(city.name);
          } else {
            ref.read(favoritesProvider.notifier).addFavorite(city);
          }
        },
      ),
      onTap: onTap,
    );
  }
}
