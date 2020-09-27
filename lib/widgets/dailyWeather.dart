import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/app_localizations.dart';

class DailyWeather extends StatelessWidget {
  final List<Weather> _dailyForecast;

  DailyWeather({List<Weather> dailyForecast}) : _dailyForecast = dailyForecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _dailyForecast.length,
        itemBuilder: (context, index) {
          var time = DateTime.fromMillisecondsSinceEpoch(
              _dailyForecast[index].time * 1000,
              isUtc: true);
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${AppLocalizations.of(context).translate('time')}: ${time.day}.${time.month}.${time.year}"),
                Text(
                    "${AppLocalizations.of(context).translate('temp')}: ${_dailyForecast[index].temperature.toString()} °C"),
              ],
            ),
          );
        },
      ),
    );
  }
}
