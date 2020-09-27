import 'package:flutter/foundation.dart';
import 'package:weather_app/models/weather.dart';

abstract class WeatherState {}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded({@required this.weather}) : assert(weather != null);
}

class WeatherFailure extends WeatherState {}
