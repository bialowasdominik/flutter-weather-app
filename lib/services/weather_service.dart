import 'dart:convert';

import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String BASE_URL =
      'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    String? cityName = placemarks.first.locality;

    print('Current city: $cityName');

    return cityName ?? 'Unknown';
  }
}