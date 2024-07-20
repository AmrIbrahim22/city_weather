import 'package:flutter/material.dart';
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
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (selectedCity != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: currentWeather.when(
                      data: (emoji) => Card(
                        elevation: 2,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 100),
                          textAlign: TextAlign.center,
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
                          title: Text(
                            city.name,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isSelectedCity
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ),
                          trailing: isSelectedCity
                              ? const Icon(Icons.check,
                                  color: Colors.blueAccent)
                              : null,
                          tileColor:
                              isSelectedCity ? Colors.blue[100] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            ref.read(currentCityProvider.notifier).state = city;
                            ref.refresh(themeProvider);
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
        ));
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
