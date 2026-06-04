# Quick Setup Guide

## Prerequisites

- Flutter 3.x (stable channel)
- Dart 3.x
- Android Studio / VS Code with Flutter extension
- A free WeatherAPI.com account

---

## Step 1 — Get your API key

1. Go to https://www.weatherapi.com/signup.aspx
2. Sign up for a free account
3. Copy your API key from the dashboard

---

## Step 2 — Configure .env

Open `assets/env/.env` and replace the placeholder:

```
WEATHER_API_KEY=your_actual_key_here
WEATHER_BASE_URL=https://api.weatherapi.com/v1
```

> ⚠️ Never commit a real API key to version control.
> The `.gitignore` already excludes `assets/env/.env`.

---

## Step 3 — Install dependencies

```bash
flutter pub get
```

---

## Step 4 — Run the app

```bash
# Android
flutter run

# Release build
flutter build apk --release
```

---

## Step 5 — Run tests

```bash
flutter test
```

---

## Architecture Cheatsheet

```
User action (UI)
      │
      ▼
WeatherNotifier (Riverpod StateNotifier)
      │
      ▼
Use Case (pure Dart, domain layer)
      │
      ▼
WeatherRepository (abstract contract)
      │
      ▼
WeatherRepositoryImpl
   ├── Online  → WeatherRemoteDataSource (Dio → WeatherAPI.com)
   │                     └── cache to Hive
   └── Offline → WeatherLocalDataSource (Hive)
```

---

## Hive Boxes

| Box | Type | Contents |
|---|---|---|
| `weather_box` | `WeatherModel` | Latest current weather per city |
| `forecast_box` | `ForecastModel` | 7-day + hourly forecast |
| `favorites_box` | `CityModel` | Saved favorite cities |
| `settings_box` | `dynamic` | Theme preference, last searched city |

---

## Adding a new feature

1. Add entity in `domain/entities/`
2. Add method to `WeatherRepository` abstract class
3. Implement in `WeatherRepositoryImpl`
4. Write a use case in `domain/usecases/`
5. Expose via Riverpod provider in `presentation/providers/`
6. Build the UI widget/screen

---

## Common Issues

**"No .env file found"**
Make sure `assets/env/.env` exists and is listed under `flutter.assets` in `pubspec.yaml`.

**"Invalid API key" (401)**
Check your key at https://www.weatherapi.com/my/ and confirm it's correctly pasted in `.env`.

**Location not working on Android emulator**
Enable location in the emulator: Extended Controls → Location → Set a location.

**Hive adapter errors on first launch**
Run `flutter clean && flutter pub get`, then rebuild. If you add new Hive models run:
```bash
dart run build_runner build --delete-conflicting-outputs
```
