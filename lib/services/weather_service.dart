import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/config/env/env.dart';
import '../config/api_endpoints.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = weatherApiKey;
  static Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      // First, get coordinates for the city
      final coordinates = await _getCoordinates(cityName);
      // Then, get weather data
      final url =
          '${ApiEndpoints.baseurl}?lat=${coordinates['lat']}&lon=${coordinates['lon']}&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data, cityName);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  static Future<WeatherModel> getCurrentWeatherByLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get weather data using coordinates
      final url =
          '${ApiEndpoints.baseurl}?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Get city name from coordinates
        final cityName =
            await _getCityName(position.latitude, position.longitude);
        return WeatherModel.fromJson(data, cityName);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data by location: $e');
    }
  }

  static Future<Map<String, double>> _getCoordinates(String cityName) async {
    try {
      final url =
          '${ApiEndpoints.geocodingUrl}?q=$cityName&limit=1&appid=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('City not found');
        }

        return {
          'lat': data[0]['lat'].toDouble(),
          'lon': data[0]['lon'].toDouble(),
        };
      } else {
        throw Exception('Failed to get coordinates');
      }
    } catch (e) {
      throw Exception('Error getting coordinates: $e');
    }
  }

  static Future<String> _getCityName(double lat, double lon) async {
    try {
      final url =
          '${ApiEndpoints.reverseGeocodingUrl}?lat=$lat&lon=$lon&limit=1&appid=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['name'] ?? 'Unknown Location';
        }
      }
      return 'Current Location';
    } catch (e) {
      return 'Current Location';
    }
  }

  static String icon(String iconCode) {
    return "${ApiEndpoints.iconUrl}/$iconCode@2x.png";
  }
}
