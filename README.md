# 🌦️ Flutter Weather App

A modern Weather Application built with Flutter using Clean Architecture, Riverpod, Dio, Hive, and OpenWeatherMap.

The app provides real-time weather information, location-based forecasts, city search, favorites management, offline support, and a beautiful Dark/Light theme experience.

---
## 📸 Screenshots

| Dashboard                                                                                                                         | Dashboard                                                                                                                         | Favorites                                                                                                                         | Settings                                                                                                                                  |
| --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://raw.githubusercontent.com/bvkbbflutter/flutter_weather_app/main/assets/screenshots/dashboard1.png" width="220"> | <img src="https://raw.githubusercontent.com/bvkbbflutter/flutter_weather_app/main/assets/screenshots/dashboard2.png" width="220"> | <img src="https://raw.githubusercontent.com/bvkbbflutter/flutter_weather_app/main/assets/screenshots/favourites.png" width="220"> | <img src="https://raw.githubusercontent.com/bvkbbflutter/flutter_weather_app/main/assets/screenshots/settings_lightmode.png" width="220"> |


## ✨ Features

### Weather

* 🌤 Current Weather
* 📍 Weather by Current Location
* 🔍 Search Weather by City
* 📅 7-Day Forecast
* 🌡 Temperature Details
* 💨 Wind Information
* 💧 Humidity Information
* 🌅 Sunrise & Sunset Data

### User Experience

* 🌙 Dark Theme
* ☀️ Light Theme
* 💾 Persistent Theme Settings
* ⭐ Favorite Cities
* 📶 Network Connectivity Monitoring
* ⚡ Fast Loading States
* 🎨 Smooth Animations

### Architecture

* Clean Architecture
* Repository Pattern
* Riverpod State Management
* Dependency Injection
* Offline Caching with Hive
* Error Handling
* Environment Configuration

---

## 🛠️ Tech Stack

### State Management

```yaml
flutter_riverpod: ^3.3.1
riverpod_annotation: ^4.0.2
```

### Networking

```yaml
dio: ^5.9.2
```

### Local Storage

```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
```

### Location

```yaml
geolocator: ^13.0.4
geocoding: ^4.0.0
```

### Utilities

```yaml
connectivity_plus: ^7.1.1
flutter_dotenv: ^6.0.1
intl: ^0.20.2
equatable: ^2.0.8
```

### UI

```yaml
cached_network_image: ^3.4.1
shimmer: ^3.0.0
lottie: ^3.3.3
```

### Code Generation

```yaml
freezed_annotation: ^3.1.0
json_annotation: ^4.12.0
```

---

## 🏗️ Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── services/
│   └── utils/
│
├── features/
│   └── weather/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/
│
└── main.dart
```

---

## 🚀 Getting Started

### Clone Repository

```bash
git clone https://github.com/bvkbbflutter/flutter_weather_app.git
```

### Install Packages

```bash
flutter pub get
```

### Environment Variables

Create a `.env` file:

```env
WEATHER_API_KEY=YOUR_API_KEY
WEATHER_BASE_URL=https://api.openweathermap.org/data/2.5
```

### Run App

```bash
flutter run
```

---

## 🌐 Weather API

Powered by:

https://openweathermap.org/api

---

## 📦 Packages Used

* Flutter Riverpod
* Riverpod Generator
* Dio
* Hive
* Geolocator
* Geocoding
* Connectivity Plus
* Freezed
* Json Serializable
* Lottie
* Cached Network Image
* Shimmer

---

## 🎯 Highlights

* Production-Ready Architecture
* Dark / Light Theme Support
* Location-Based Weather
* Favorites Management
* Offline Data Storage
* Clean and Scalable Codebase

---

## 👨‍💻 Author

**BVKBB Flutter**

GitHub:

https://github.com/bvkbbflutter

Project Repository:

https://github.com/bvkbbflutter/flutter_weather_app

---

## 📄 License

MIT License
