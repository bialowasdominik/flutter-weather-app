import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('API-KEY-HERE');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try{
      Weather weather = await _weatherService.fetchWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  String getWeatherIcon(String? condition) {
    if (condition == null) return 'assets/sunny.json';
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.json';
      case 'cloud':
        return 'assets/cloud.json';
      case 'rain':
       return 'assets/rainy.json';
      case 'snow':
        return 'assets/snow.json';
      case 'fog':
        return 'assets/mist.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'wind':
        return 'assets/windy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding:  EdgeInsets.only(bottom: 20), child: Icon(
            CupertinoIcons.location_solid,
            size: 18,
            color: Color(0xFFB0B0B5),
            
          )),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _weather != null
                ? Text(
                    _weather!.cityName.toUpperCase(),
                    key: const ValueKey('city'),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB0B0B5),
                    ),
                  )
                : const SizedBox(
                    key: ValueKey('loader'),
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFB0B0B5)),
                    ),
                  ),
          ),
          Lottie.asset(getWeatherIcon(_weather?.mainCondition), width: 550, height: 600),
          Text(_weather != null ? '${_weather!.temperature.round()}°':'',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 48,
                color: Color(0xFFB0B0B5),
              )),
        ],
      ),
      ),
    );
  }
}