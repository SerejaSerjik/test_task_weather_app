import 'location.dart';

class Weather {
  int time;
  num temperature;

  List<Weather> dailyForecast;
  List<Weather> hourlyForecast;

  Location location;

  Weather({
    this.time,
    this.temperature,
    this.dailyForecast,
    this.hourlyForecast,
    this.location,
  });

  static List<Weather> getHourlyForecastFromJson(Map<String, dynamic> json) {
    final weathers = List<Weather>();
    for (var i = 0; i < 12; i++) {
      var item = json['hourly'][i];
      weathers.add(Weather(
        time: item['dt'],
        temperature: item['temp'],
      ));
    }
    return weathers;
  }

  static List<Weather> getDailyForecastFromJson(Map<String, dynamic> json) {
    final weathers = List<Weather>();
    for (var i = 0; i < 7; i++) {
      var item = json['daily'][i];
      weathers.add(Weather(
        time: item['dt'],
        temperature: item['temp']['day'],
      ));
    }
    return weathers;
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'temperature': temperature,
      'dailyForecast': dailyForecast?.map((x) => x?.toMap())?.toList(),
      'hourlyForecast': hourlyForecast?.map((x) => x?.toMap())?.toList(),
      'location': location?.toMap(),
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Weather(
      time: map['time'],
      temperature: map['temperature'],
      dailyForecast: List<Weather>.from(
          map['dailyForecast']?.map((x) => Weather.fromMap(x))),
      hourlyForecast: List<Weather>.from(
          map['hourlyForecast']?.map((x) => Weather.fromMap(x))),
      location: Location.fromMap(map['location']),
    );
  }
}
