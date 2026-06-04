import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_notifier.dart';
import '../providers/weather_state.dart';
import '../providers/weather_providers.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/weather_stat_card.dart';
import '../widgets/offline_banner.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialWeather());
  }

  Future<void> _loadInitialWeather() async {
    final local = ref.read(localDataSourceProvider);
    final lastCity = await local.getLastCity();
    if (lastCity != null) {
      ref.read(weatherNotifierProvider.notifier).loadWeather(lastCity);
    } else {
      ref.read(weatherNotifierProvider.notifier).loadCurrentLocationWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);
    final connectivity = ref.watch(connectivityProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SearchScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text('Search city...',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    onPressed: () => ref
                        .read(weatherNotifierProvider.notifier)
                        .loadCurrentLocationWeather(),
                    tooltip: 'Use my location',
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                ],
              ),
            ),

            // Offline banner
            connectivity.when(
              data: (isOnline) => isOnline ? const SizedBox.shrink() : const OfflineBanner(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Main content
            Expanded(
              child: switch (weatherState) {
                WeatherInitial() => _buildInitialState(),
                WeatherLoading() => _buildLoadingState(),
                WeatherLoaded(:final weather, :final forecast, :final isFromCache) =>
                  RefreshIndicator(
                    onRefresh: () =>
                        ref.read(weatherNotifierProvider.notifier).refreshWeather(),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (isFromCache)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildCacheBanner(context),
                          ),
                        CurrentWeatherCard(weather: weather),
                        const SizedBox(height: 16),
                        WeatherStatsRow(weather: weather),
                        const SizedBox(height: 16),
                        if (forecast.isNotEmpty) ...[
                          HourlyForecastList(
                            hourly: forecast.first.hourly,
                          ),
                          const SizedBox(height: 16),
                          DailyForecastList(forecast: forecast),
                        ],
                      ],
                    ),
                  ),
                WeatherError(:final message) => _buildErrorState(message),
                WeatherOfflineEmpty() => _buildOfflineEmptyState(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Search for a city or use your location',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );

  Widget _buildLoadingState() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching weather...'),
          ],
        ),
      );

  Widget _buildErrorState(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(weatherNotifierProvider.notifier).refreshWeather(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );

  Widget _buildOfflineEmptyState() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No internet & no cached data.',
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Connect to the internet to get started.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );

  Widget _buildCacheBanner(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.history, size: 16, color: Colors.orange),
            SizedBox(width: 8),
            Text('Showing cached data', style: TextStyle(color: Colors.orange, fontSize: 13)),
          ],
        ),
      );
}
