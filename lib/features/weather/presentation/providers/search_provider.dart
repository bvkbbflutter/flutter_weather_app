import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/usecases/weather_usecases.dart';
import 'weather_providers.dart';

sealed class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<CityEntity> results;
  const SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchCityUseCase _searchCity;

  SearchNotifier(this._searchCity) : super(const SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchInitial();
      return;
    }
    state = const SearchLoading();
    final result = await _searchCity(query.trim());
    state = result.fold(
      (failure) => SearchError(failure.message),
      (cities) =>
          cities.isEmpty ? const SearchLoaded([]) : SearchLoaded(cities),
    );
  }

  void clear() => state = const SearchInitial();
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(ref.watch(searchCityUseCaseProvider));
});
