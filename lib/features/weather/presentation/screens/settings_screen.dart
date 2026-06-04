import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_providers.dart';
import '../providers/weather_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle light / dark theme'),
            value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          const Divider(),
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.cached),
            title: const Text('Clear Weather Cache'),
            subtitle: const Text('Remove all locally stored weather data'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content:
                      const Text('This will remove all cached weather data. Continue?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Clear',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(localDataSourceProvider).clearWeatherCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared successfully.')),
                  );
                }
              }
            },
          ),
          const Divider(),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('API Provider'),
            subtitle: Text('WeatherAPI.com (Free Tier)'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      );
}
