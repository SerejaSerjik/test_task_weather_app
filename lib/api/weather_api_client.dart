import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/weather.dart';

class WeatherApiClient {
  static const baseUrl = 'http://api.openweathermap.org';
  final apiKey;
  final http.Client httpClient;

  WeatherApiClient({@required this.httpClient, this.apiKey})
      : assert(httpClient != null),
        assert(apiKey != null);

  Future<Map<String, List<Weather>>> getForecast({Location location}) async {
    final url =
        '$baseUrl/data/2.5/onecall?lat=${location.latitude}&lon=${location.longtitude}&exclude=current,minutely,alerts&appid=$apiKey&units=metric';
    print('fetching $url');
    final res = await this.httpClient.get(url);
    final jsonRes = json.decode(res.body);
    List<Weather> hourlyForecast = Weather.getHourlyForecastFromJson(jsonRes);
    List<Weather> dailyForecast = Weather.getDailyForecastFromJson(jsonRes);
    Map<String, List<Weather>> forecast = {
      'hourlyForecast': [],
      'dailyForecast': [],
    };
    forecast['hourlyForecast'] = hourlyForecast;
    forecast['dailyForecast'] = dailyForecast;
    return forecast;
  }
}
