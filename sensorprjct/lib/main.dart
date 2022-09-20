import 'package:flutter/material.dart';
import 'package:environment_sensors/environment_sensors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Today's Temperature"),
    );
  }
}

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
  double tempNum = 15.0;

  Color temp_colorDecision(double temp) {
    if (temp >= 26.6) {
      return Color.fromARGB(255, 237, 93, 27);
    } else if (temp <= 10) {
      return Color.fromARGB(255, 71, 129, 176);
    }
    return Color.fromARGB(255, 176, 161, 24);
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          color: temp_colorDecision(tempNum),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RotationTransition(
                    turns: Tween(begin: 0.0, end: -.25)
                        .chain(CurveTween(curve: Curves.elasticIn))
                        .animate(_animationController),
                    child: Icon((Icons.thermostat), size:150)),
                RaisedButton(
                  child: Text("Run animation"),
                  onPressed: () => _runAnimation(),
                ),
                StreamBuilder<double>(
                    stream: environment.temperature,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        double? tempReading = snapshot.data;
                        if (tempReading != null) {
                          tempNum = tempReading.toDouble();
                        }
                      }
                      return Text(
                          'The Current Temperature is: ${snapshot.data}',textScaleFactor: 1.75);
                    }),
                StreamBuilder<double>(
                    stream: environment.humidity,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return Text('The Current Humidity is: ${snapshot.data}', textScaleFactor: 1.75);
                    }),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 50, left: 250),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondRoute()),
                          );
                        },
                        child: const Text("Next Screen"))),
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class SecondRoute extends StatefulWidget {
  SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute>
with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;

  final environment = EnvironmentSensors();
  double baroNum = 0.0;

@override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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

  Color baro_colorDecision(double pressure) {
    if (pressure >= 1000) {
      return Color.fromARGB(255, 78, 77, 77);
    } else if (pressure < 500) {
      return Color.fromARGB(248, 191, 201, 120);
    }
    return Color.fromARGB(248, 233, 235, 228);
  }

  IconData baro_iconDecision(double pressure) {
    if (pressure >= 1000.00) {
      return Icons.thunderstorm;
    } else if (pressure < 500) {
      return Icons.sunny;
    } else {
      return Icons.foggy;
    }
  }

  Color icon_colorDesicion(double pressure) {
    if (pressure >= 1000.00) {
      return Colors.black;
    } else if (pressure < 500) {
      return Colors.yellow;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's Weather"),
        ),
        body: Container(
          color: baro_colorDecision(baroNum),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RotationTransition(
                    turns: Tween(begin: 0.0, end: -.25)
                        .chain(CurveTween(curve: Curves.elasticIn))
                        .animate(_animationController),
                    child: Icon(baro_iconDecision(baroNum),
                            color: icon_colorDesicion(baroNum),
                            size: 150,
                     // color: icon_colorDesicion(baroNum),
                    )
                  ),
                RaisedButton(
                  child: Text("Run animation"),
                  onPressed: () => _runAnimation(),
                ),
                StreamBuilder<double>(
                    stream: environment.pressure,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        double? baroPressure = snapshot.data;
                        if (baroPressure != null) {
                          baroNum = baroPressure.toDouble();
                        }
                      }
                      return Text("The Current Pressure is: ${snapshot.data}", textScaleFactor: 1.75);
                      //if pressure > smth, return darkgrey and rainy icon
                      //if pressure < smth, return yellow and sunny icon
                      //else return cloudy icon and grey
                    }),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go back!'),
                )
              ])),
        ));
  }
}
