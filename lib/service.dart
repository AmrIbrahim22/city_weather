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

final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getCityWeather(city);
  } else {
    return "🤷‍♀️";
  }
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_defaultTheme);

  static final ThemeData _defaultTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.blue[50], // Blue sky color
  );

  void updateTheme(City? city) {
    state = _getTheme(city);
  }

  static ThemeData _getTheme(City? city) {
    switch (city) {
      case City.cairo:
        return ThemeData.light().copyWith(
          primaryColor: Colors.orangeAccent,
          scaffoldBackgroundColor: Colors.yellow[100],
        );
      case City.london:
        return ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.blueGrey[900],
        );
      case City.paris:
        return ThemeData.light().copyWith(
          primaryColor: Colors.pinkAccent,
          scaffoldBackgroundColor: Colors.pink[50],
        );
      case City.doha:
        return ThemeData.dark().copyWith(
          primaryColor: Colors.redAccent,
          scaffoldBackgroundColor: Colors.red[900],
        );
      default:
        return _defaultTheme; // Default theme for when no city is selected
    }
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  final city = ref.watch(currentCityProvider.notifier).state;
  final notifier = ThemeNotifier();
  notifier.updateTheme(city); // Initial theme setup
  return notifier;
});
