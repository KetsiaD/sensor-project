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
      home: const NavigationScaffold()
    );
  }
}

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {

  int screenIndex = 0;
  final screens = const [
    MyHomePage(),
    WeatherPage()
  ];

  void updateScreenIndex(int newScreenIndex) {
    setState(() {
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
            label: "Temp"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: "Weather"
          ),
        ],
        onTap: updateScreenIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
