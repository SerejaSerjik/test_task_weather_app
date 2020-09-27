import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/api/weather_api_client.dart';
import 'package:weather_app/bloc/auth/auth.dart';
import 'package:weather_app/bloc/weather/weather.dart';
import 'package:weather_app/models/message.dart';
import 'package:weather_app/services/weather_repository.dart';
import 'package:weather_app/utils/apiKeys.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/app_localizations.dart';
import 'package:weather_app/widgets/dailyWeather.dart';
import 'package:weather_app/widgets/hourlyWeather.dart';

class HomePage extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(
          httpClient: http.Client(), apiKey: ApiKey.OPEN_WEATHER_MAP));

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectBoxValue = 1;
  WeatherBloc _weatherBloc;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _firebaseMessaging.configure(
      onMessage: (message) async {
        final notification = message['notification'];
        setState(() {
          messages.add(
            Message(
              title: notification['title'],
              body: notification['body'],
            ),
          );
        });
      },
      onLaunch: (message) async {
        print("onLaunch $message");
      },
      onResume: (message) async {
        print("onResume $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(AppLocalizations.of(context).translate('home_page_title')),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                final list = List<PopupMenuEntry<Object>>();
                list.add(PopupMenuItem(
                  value: 1,
                  child: Text(
                    AppLocalizations.of(context).translate('weather_by_hours'),
                  ),
                ));
                list.add(PopupMenuItem(
                  value: 2,
                  child: Text(
                    AppLocalizations.of(context).translate('weather_by_days'),
                  ),
                ));
                return list;
              },
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                setState(() {
                  selectBoxValue = value;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                authBloc.add(LoggedOut());
              },
            )
          ],
        ),
        body: SafeArea(
          child: BlocProvider<WeatherBloc>(
            create: (context) =>
                WeatherBloc(weatherRepository: widget.weatherRepository)
                  ..add(FetchWeather()),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                print(state);
                if (state is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is WeatherLoaded) {
                  if (selectBoxValue == 1) {
                    return HourlyWeather(
                        hourlyForecast: state.weather.hourlyForecast);
                  } else if (selectBoxValue == 2) {
                    return DailyWeather(
                        dailyForecast: state.weather.dailyForecast);
                  }
                }
                if (state is WeatherFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Oops, something went wrong..."),
                        RaisedButton(
                          child: Text("Try again"),
                          onPressed: () {
                            _weatherBloc.add(FetchWeather());
                          },
                        )
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
