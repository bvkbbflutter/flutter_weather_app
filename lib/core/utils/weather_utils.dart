import 'package:intl/intl.dart';

class WeatherUtils {
  static String formatTemp(double temp, {bool isCelsius = true}) {
    final rounded = temp.round();
    return '$rounded°${isCelsius ? 'C' : 'F'}';
  }

  static String formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);
  static String formatDay(DateTime dt) => DateFormat('EEEE').format(dt);
  static String formatShortDay(DateTime dt) => DateFormat('EEE').format(dt);
  static String formatDate(DateTime dt) => DateFormat('MMM d').format(dt);

  static String getWeatherIconUrl(String iconCode) =>
      'https:$iconCode';

  static String windDirection(int degree) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((degree / 45) % 8).round() % 8];
  }

  static String uvIndexDescription(double uvi) {
    if (uvi < 3) return 'Low';
    if (uvi < 6) return 'Moderate';
    if (uvi < 8) return 'High';
    if (uvi < 11) return 'Very High';
    return 'Extreme';
  }
}
