import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:weather_app/screens/home_page.dart';

void main() {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomePage());
  }
}
