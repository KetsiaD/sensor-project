import 'dart:async';

import 'package:flutter/material.dart';
import 'package:environment_sensors/environment_sensors.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;

  final environment = EnvironmentSensors();
  double baroNum = 550;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  //initialize weather colors and icons
  Color baro_color = Colors.grey;
  IconData baro_icon = Icons.sunny;
  Color baro_icon_color = Colors.grey;

  //dynamically updates the background color, weather icon, and weather icon color
  //this is determined using pressure sensor logic
  baro_dynamicDecision(double pressure) {
    Color bg_color;
    IconData icon;
    Color icon_color;
    if (pressure >= 1000) {
      bg_color = const Color.fromARGB(255, 78, 77, 77);
      icon = Icons.thunderstorm;
      icon_color = Colors.black;
    } else if (pressure < 500) {
      bg_color = const Color.fromARGB(248, 191, 201, 120);
      icon = Icons.sunny;
      icon_color = Colors.yellow;
    } else {
      bg_color = const Color.fromARGB(248, 233, 235, 228);
      icon = Icons.foggy;
      icon_color = Colors.blue;
    }
    setState(() {
      baro_color = bg_color;
      baro_icon = icon;
      baro_icon_color = icon_color;
    });
  }

//second screen for displaying the weather
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's Weather"),
        ),
        body: Container(
          color: baro_color,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                RotationTransition(
                    turns: Tween(begin: 0.0, end: -.25)
                        .chain(CurveTween(curve: Curves.elasticIn))
                        .animate(_animationController),
                    child: Icon(
                      baro_icon,
                      color: baro_icon_color,
                      size: 150,
                    )),
                ElevatedButton(
                  key: const Key("2ndAnimation"),
                  child: const Text("Run animation"),
                  onPressed: () => _runAnimation(),
                ),
                StreamBuilder<double>(
                    stream: environment.pressure,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        double? baroPressure = snapshot.data;
                        if (baroPressure != null) {
                          baroNum = baroPressure.toDouble();
                          Future.delayed(Duration.zero, () async {
                            baro_dynamicDecision(baroNum);
                          });
                        }
                      }
                      return Text("The Current Pressure is: ${snapshot.data}",
                          textScaleFactor: 1.75);
                    }),
                ElevatedButton(
                  key: const Key("2ndKey"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back!'),
                )
              ])),
        ));
  }
}
