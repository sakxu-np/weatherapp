import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherDisplayWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDisplayWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Location
          Text(
            weather.cityName?.toUpperCase() ?? "Unknown Location",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Weather Icon and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                WeatherService.icon(weather.icon ?? '01d'),
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.cloud,
                    color: Colors.black,
                    size: 100,
                  );
                },
              ),
              const SizedBox(width: 16),
              Text(
                '${weather.temperature?.round()}°C',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          // Description
          Text(
            (weather.description ?? "").toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like ${weather.feelsLike?.round()}°C',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),

          // Weather Details
          WeatherDetailsCard(weather: weather),
        ],
      ),
    );
  }
}

class WeatherDetailsCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherDetailItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
              WeatherDetailItem(
                icon: Icons.air,
                label: 'Wind Speed',
                value: '${weather.windSpeed?.toStringAsFixed(1)} m/s',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherDetailItem(
                icon: Icons.compress,
                label: 'Pressure',
                value: '${weather.pressure} hPa',
              ),
              WeatherDetailItem(
                icon: Icons.visibility,
                label: 'Visibility',
                value: '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeatherDetailItem(
                icon: Icons.wb_sunny,
                label: 'Sunrise',
                value: _formatTime(weather.sunrise!),
              ),
              WeatherDetailItem(
                icon: Icons.brightness_3,
                label: 'Sunset',
                value: _formatTime(weather.sunset!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
