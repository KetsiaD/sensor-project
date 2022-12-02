import 'dart:async';

import 'package:flutter/material.dart';
import 'package:environment_sensors/environment_sensors.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

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
  Color baroColor = Colors.grey;
  IconData baroIcon = Icons.sunny;
  Color baroIconColor = Colors.grey;

  //dynamically updates the background color, weather icon, and weather icon color
  //this is determined using pressure sensor logic
  baroDynamicDecision(double pressure) {
    Color bgColor;
    IconData icon;
    Color iconColor;
    if (pressure >= 1000) {
      bgColor = const Color.fromARGB(255, 78, 77, 77);
      icon = Icons.thunderstorm;
      iconColor = Colors.black;
    } else if (pressure < 500) {
      bgColor = const Color.fromARGB(248, 191, 201, 120);
      icon = Icons.sunny;
      iconColor = Colors.yellow;
    } else {
      bgColor = const Color.fromARGB(248, 233, 235, 228);
      icon = Icons.foggy;
      iconColor = Colors.blue;
    }
    setState(() {
      baroColor = bgColor;
      baroIcon = icon;
      baroIconColor = iconColor;
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
          color: baroColor,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                RotationTransition(
                    turns: Tween(begin: 0.0, end: -.25)
                        .chain(CurveTween(curve: Curves.elasticIn))
                        .animate(_animationController),
                    child: Icon(
                      baroIcon,
                      color: baroIconColor,
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
                            baroDynamicDecision(baroNum);
                          });
                        }
                      }
                      return Text("The Current Pressure is: ${snapshot.data}",
                          textScaleFactor: 1.75);
                    }),
              ])),
        ));
  }
}
