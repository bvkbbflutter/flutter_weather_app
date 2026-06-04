# Flutter Weather App

A production-ready Flutter Weather App built with Clean Architecture, Riverpod state management,
Hive local caching, and an Offline-First approach.

---

## Tech Stack

| Layer | Technology |
|---|---|
| State Management | flutter_riverpod |
| Local Database | hive + hive_flutter |
| Networking | dio |
| Location | geolocator + geocoding |
| Connectivity | connectivity_plus |
| Environment | flutter_dotenv |
| Architecture | Clean Architecture (Feature-First) |

---

## Project Structure

```
lib/
  core/
    constants/       # App-wide constants & Hive keys
    errors/          # Failures, exceptions, Either monad
    network/         # Dio client with interceptors & retry
    services/        # Connectivity, Location services
    storage/         # Hive initialization
    theme/           # Light & Dark themes
    utils/           # Weather formatting utilities
  features/
    weather/
      data/
        datasources/
          local/     # Hive-based local cache
          remote/    # WeatherAPI.com via Dio
        models/      # Hive models + JSON parsing
        repositories/ # Offline-first WeatherRepositoryImpl
      domain/
        entities/    # Pure Dart domain entities
        repositories/ # Abstract repository contract
        usecases/    # Business logic use cases
      presentation/
        providers/   # Riverpod: notifiers, providers, states
        screens/     # Home, Search, Favorites, Settings
        widgets/     # Reusable UI components
```

---

## Setup

### 1. Get an API key

Sign up at [https://www.weatherapi.com](https://www.weatherapi.com) (free tier works for all features).

### 2. Configure environment

Open `assets/env/.env` and add your API key:

```
WEATHER_API_KEY=your_actual_api_key_here
WEATHER_BASE_URL=https://api.weatherapi.com/v1
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```

---

## Hive Adapters

Hive TypeAdapters are pre-written (no build_runner needed for adapters).

If you add new Hive models, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Offline-First Flow

```
User opens app
      │
      ▼
Check connectivity
      │
   ┌──┴──┐
Online    Offline
  │           │
  ▼           ▼
Fetch API   Return cached data
  │           │
  ▼        No cache?
Cache to     │
Hive       Show empty state
  │
  ▼
Return fresh data
```

---

## Running Tests

```bash
flutter test
```

---

## API Reference

This app uses **WeatherAPI.com** (recommended over OpenWeatherMap free tier):

| Endpoint | Used for |
|---|---|
| `/current.json` | Current weather |
| `/forecast.json` | 7-day forecast + hourly |
| `/search.json` | City search autocomplete |

---

## Features

- Current weather with all stats (humidity, wind, UV, pressure, visibility)
- 24-hour hourly forecast
- 7-day daily forecast
- City search with debounce
- Favorite cities (persisted in Hive)
- Current location weather (geolocator)
- Offline support with Hive cache
- Offline banner + cache indicator
- Pull-to-refresh
- Light/Dark theme toggle (persisted in Hive)
- Cache management in Settings
