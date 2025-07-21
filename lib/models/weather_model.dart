class WeatherModel {
  final String? cityName;
  final double? temperature;
  final String? description;
  final String? icon;
  final num? humidity;
  final double? windSpeed;
  final num? pressure;
  final double? feelsLike;
  final num? visibility;
  final DateTime? sunrise;
  final DateTime? sunset;
  final String? name;

  WeatherModel({
    this.cityName,
    this.temperature,
    this.description,
    this.icon,
    this.humidity,
    this.windSpeed,
    this.pressure,
    this.feelsLike,
    this.visibility,
    this.sunrise,
    this.sunset,
    this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];
    final sys = json['sys'];

    return WeatherModel(
      cityName: cityName,
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'],
      icon: weather['icon'],
      humidity: main['humidity'],
      windSpeed: wind != null ? (wind['speed'] as num).toDouble() : 0.0,
      pressure: main['pressure'],
      feelsLike: (main['feels_like'] as num).toDouble(),
      visibility: (json['visibility'] as num?) ?? 10000,
      sunrise: sys != null && sys['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)
          : null,
      sunset: sys != null && sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)
          : null,
      name: main['name'] as String? ?? cityName,
    );
  }
}
