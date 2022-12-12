import 'package:sensorprjct/temperature.dart';
import 'package:sensorprjct/weather.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NavigationScaffold());
  }
}

void _LoadingPopUp(BuildContext context) async {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                LinearProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text('One Moment, loading')
              ],
            ),
          ),
        );
      });
  await Future.delayed(const Duration(seconds: 5));
  Navigator.of(context).pop();
}

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int screenIndex = 0;
  final screens = const [MyHomePage(), WeatherPage()];

  void updateScreenIndex(int newScreenIndex) {
    setState(() {
      _LoadingPopUp(context);
      screenIndex = newScreenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.thermostat),
              label: "Temperature",
              tooltip: "Temperature and Humidity"),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: "Weather",
              tooltip: "Barometric Pressure"),
        ],
        onTap: updateScreenIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
