import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_repository.dart';

import 'weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc({@required weatherRepository})
      : assert(weatherRepository != null),
        _weatherRepository = weatherRepository,
        super(WeatherEmpty());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather weather = await _weatherRepository.getWeather();
        yield WeatherLoaded(weather: weather);
      } catch (e) {
        print("Error: $e");
        yield WeatherFailure();
      }
    }
  }
}
