import 'dart:async';
import 'package:sensorprjct/weather.dart';
import 'package:flutter/material.dart';
import 'package:environment_sensors/environment_sensors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;

  final environment = EnvironmentSensors();
  double tempNum = 15;
  double humidity = 50;

  //initialize temperature color
  Color temp_color = Colors.grey;
//logic for handling color decisions
  temp_colorDecision(double temp) {
    Color color;
    if (temp >= 26.6) {
      color = const Color.fromARGB(255, 237, 93, 27);
    } else if (temp <= 10) {
      color = const Color.fromARGB(255, 71, 129, 176);
    } else {
      color = const Color.fromARGB(255, 176, 161, 24);
    }
    setState(() {
      temp_color = color;
    });
  }

//initializes animated icons
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

//simple looping of animated icons
  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

//stops animation
  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

//first screen for displaying the temperature
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          color: temp_color,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RotationTransition(
                    key: const Key("Animation"),
                    turns: Tween(begin: 0.0, end: -.25)
                        .chain(CurveTween(curve: Curves.elasticIn))
                        .animate(_animationController),
                    child: const Icon((Icons.thermostat), size: 150)),
                ElevatedButton(
                  key: const Key("TempAnimation"),
                  child: const Text("Run animation"),
                  onPressed: () => _runAnimation(),
                ),
                StreamBuilder<double>(
                    stream: environment.temperature,
                    initialData: tempNum,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        double? tempReading = snapshot.data;
                        if (tempReading != null) {
                          tempNum = tempReading.toDouble();
                          Future.delayed(Duration.zero, () async {
                            temp_colorDecision(tempNum);
                          });
                        }
                      }
                      return Text(
                          'The Current Temperature is: ${snapshot.data}°C',
                          textScaleFactor: 1.73);
                    }),
                StreamBuilder<double>(
                    stream: environment.humidity,
                    initialData: humidity,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      return Text('The Current Humidity is: ${snapshot.data}%',
                          textScaleFactor: 1.75);
                    }),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 50, left: 250),
                    child: ElevatedButton(
                        key: const Key("SwitchKey"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeatherPage()),
                          );
                        },
                        child: const Text("Next Screen"))),
              ],
            ),
          ),
        ));
  }
}
