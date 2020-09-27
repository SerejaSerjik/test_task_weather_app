import 'package:flutter/foundation.dart';
import 'package:weather_app/api/weather_api_client.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;
  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather() async {
    Location location = Location();
    //TODO add permission check
    await location.getCurrentLocation();
    final Weather weather = Weather();
    final weatherForecast =
        await weatherApiClient.getForecast(location: location);
    weather.hourlyForecast = weatherForecast['hourlyForecast'];
    weather.dailyForecast = weatherForecast['dailyForecast'];
    weather.location = location;
    return weather;
  }
}
