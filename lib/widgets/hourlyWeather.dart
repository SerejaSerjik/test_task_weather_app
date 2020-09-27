import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/app_localizations.dart';

class HourlyWeather extends StatelessWidget {
  final List<Weather> _hourlyForecast;

  HourlyWeather({List<Weather> hourlyForecast})
      : _hourlyForecast = hourlyForecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _hourlyForecast.length,
        itemBuilder: (context, index) {
          var time = DateTime.fromMillisecondsSinceEpoch(
              _hourlyForecast[index].time * 1000,
              isUtc: true);
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${AppLocalizations.of(context).translate('time')}: ${time.hour}:${time.minute}:${time.second}"),
                Text(
                    "${AppLocalizations.of(context).translate('temp')}: ${_hourlyForecast[index].temperature.toString()} °C"),
              ],
            ),
          );
        },
      ),
    );
  }
}
