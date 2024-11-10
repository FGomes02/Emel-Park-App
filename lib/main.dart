import 'package:flutter/material.dart';
import 'package:projeto1/providers/ParkingLotProvider.dart';
import 'package:projeto1/providers/incident_provider.dart';
import 'package:projeto1/pages/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF004f6d));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ParkingLotProvider()),
        ChangeNotifierProvider(create: (context) => IncidentProvider()),
      ],
      child: MaterialApp(
        title: 'EmelPark',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          appBarTheme:
              ThemeData.from(colorScheme: colorScheme).appBarTheme.copyWith(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.background,
                  ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
