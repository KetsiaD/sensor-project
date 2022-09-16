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

class _MyHomePageState extends State<MyHomePage> {
  double temp = 0;
  final environment = EnvironmentSensors();
  Color bgColorT = Colors.orange;
  Color bgColorW = Colors.grey;
  IconData icon = Icons.thermostat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        color : bgColorT,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            // put thermostat here
            StreamBuilder<double>(
                stream: environment.temperature,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Text('The Current Temperature is: ${snapshot.data}');
                  //(if snapshot.data >= 80.0) return Colors.Red; 
                  //if snapshot.data <=55.0, return Colors.Blue;
                  //else return Colors.Yellow;
                }),
            StreamBuilder<double>(
                stream: environment.humidity,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Text('The Current Humidity is: ${snapshot.data}');
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
                        MaterialPageRoute(builder: (context) => SecondRoute()),
                      );
                    },
                    child: const Text("Next Screen"))),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    )
  );
}
}

class SecondRoute extends StatelessWidget {
  SecondRoute({super.key});

  final environment = EnvironmentSensors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //use bgcolorW here w a late
      appBar: AppBar(
        title: const Text("Today's Weather"),
      ),
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            //put Icon here and change/add the pressure tables
            StreamBuilder<double>(
                stream: environment.pressure,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Text('The Current Pressure is: ${snapshot.data}');
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
    )
    );
  }
}
