import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_riverpod_demo/city.dart';

typedef WeatherEmoji = String;
Future<WeatherEmoji> getCityWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {
          City.cairo: '☀',
          City.london: '🌧',
          City.paris: '🌈',
          City.doha: '🌡'
        }[city] ??
        "🌝",
  );
}

// ui will read from amd write to amd could be changed by ui like button or textfield
final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getCityWeather(city);
  } else {
    return "🤷‍♀️";
  }
});
final themeProvider = Provider<ThemeData>((ref) {
  final city = ref.watch(currentCityProvider.notifier).state;
  return _getTheme(city);
});

ThemeData _getTheme(City? city) {
  switch (city) {
    case City.cairo:
      return ThemeData.light().copyWith(
        primaryColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.yellow[300],
      ); // Light theme for sunny weather
    case City.london:
      return ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ); // Dark theme for rainy weather
    case City.paris:
      return ThemeData.light().copyWith(
        primaryColor: Colors.pinkAccent,
        scaffoldBackgroundColor: Colors.pink[50],
      ); // Light theme for rainbow weather
    case City.doha:
      return ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.red[900],
      ); // Dark theme for hot weather
    default:
      return ThemeData.light(); // Default light theme
  }
}
