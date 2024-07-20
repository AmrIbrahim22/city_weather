import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_riverpod_demo/city.dart';
import 'package:weather_riverpod_demo/service.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);

    return MaterialApp(
      theme: theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    final selectedCity = ref.watch(currentCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (selectedCity == null)
                const Expanded(
                  child: Center(
                    child: Card(
                      elevation: 2,
                      child: Text(
                        "🤷‍♀️", // Shrug emoji
                        style: TextStyle(fontSize: 100),
                      ),
                    ),
                  ),
                )
              else if (selectedCity != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: currentWeather.when(
                      data: (emoji) => Card(
                        elevation: 2,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 100),
                        ),
                      ),
                      error: (error, stack) => const Text(
                        "❓",
                        style: TextStyle(fontSize: 100),
                      ),
                      loading: () => const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        strokeWidth: 6.0,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: AnimatedList(
                  initialItemCount: City.values.length,
                  itemBuilder: (context, index, animation) {
                    final city = City.values[index];
                    final isSelectedCity =
                        city == ref.watch(currentCityProvider);
                    return SlideTransition(
                      position: animation.drive(
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.location_city,
                              color: isSelectedCity
                                  ? Colors.blueAccent
                                  : Colors.black),
                          title: Text(
                            city.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isSelectedCity
                                  ? Colors.blueAccent
                                  : Colors.black,
                              shadows: isSelectedCity
                                  ? [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          tileColor:
                              isSelectedCity ? Colors.blue[100] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            ref.read(currentCityProvider.notifier).state = city;
                            ref
                                .read(themeNotifierProvider.notifier)
                                .updateTheme(city); // Update the theme
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String data;
  const WeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny,
              color: Colors.orange,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 40,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
