import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/popular_cities_widget.dart';
import '../widgets/weather_display_widget.dart';
import '../widgets/common_widgets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Future<WeatherModel>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Load weather for current location by default
    _loadWeatherByLocation();
  }

  void _loadWeatherByCity(String cityName) {
    if (cityName.trim().isEmpty) return;

    setState(() {
      if (cityName == 'Current Location') {
        _weatherFuture = WeatherService.getCurrentWeatherByLocation();
      } else {
        _weatherFuture = WeatherService.getCurrentWeather(cityName);
      }
    });
  }

  void _loadWeatherByLocation() {
    setState(() {
      _weatherFuture = WeatherService.getCurrentWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Section
                SearchSection(
                  controller: _cityController,
                  onSubmitted: _loadWeatherByCity,
                  onLocationPressed: _loadWeatherByLocation,
                ),
                const SizedBox(height: 24),

                // Weather Content
                Expanded(
                  child: _weatherFuture == null
                      ? const LoadingWidget()
                      : FutureBuilder<WeatherModel>(
                          future: _weatherFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingWidget();
                            }

                            if (snapshot.hasError) {
                              return WeatherErrorWidget(
                                error: snapshot.error.toString(),
                                onRetry: () {
                                  if (_cityController.text.isNotEmpty) {
                                    _loadWeatherByCity(_cityController.text);
                                  } else {
                                    _loadWeatherByLocation();
                                  }
                                },
                              );
                            }

                            if (!snapshot.hasData) {
                              return const NoDataWidget();
                            }

                            return WeatherDisplayWidget(
                                weather: snapshot.data!);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}

class SearchSection extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback onLocationPressed;

  const SearchSection({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SearchBarWidget(
            controller: controller,
            onSubmitted: onSubmitted,
            onLocationPressed: onLocationPressed,
          ),
          const SizedBox(height: 12),
          PopularCitiesWidget(
            onCityTap: onSubmitted,
          ),
        ],
      ),
    );
  }
}
