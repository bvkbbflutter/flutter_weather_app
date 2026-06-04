import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/city_entity.dart';
import '../../data/repositories/weather_repository_impl.dart';
import 'weather_providers.dart';

class FavoritesNotifier extends StateNotifier<List<CityEntity>> {
  final WeatherRepositoryImpl _repository;

  FavoritesNotifier(this._repository) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final result = await _repository.getFavoriteCities();
    result.fold((_) => state = [], (cities) => state = cities);
  }

  Future<void> addFavorite(CityEntity city) async {
    final result = await _repository.saveFavoriteCity(city);
    result.fold((_) => null, (_) => state = [...state, city]);
  }

  Future<void> removeFavorite(String cityName) async {
    final result = await _repository.removeFavoriteCity(cityName);
    result.fold(
      (_) => null,
      (_) => state = state.where((c) => c.name != cityName).toList(),
    );
  }

  bool isFavorite(String cityName) => state.any((c) => c.name == cityName);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<CityEntity>>((ref) {
      return FavoritesNotifier(ref.watch(weatherRepositoryImplProvider));
    });
