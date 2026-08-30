import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const AdaptiveApp());

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Platform detection: iOS gets CupertinoApp, everything else gets MaterialApp
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return const CupertinoApp(
        title: 'responsivedashboard',
        home: DashboardScreen(),
      );
    }
    return MaterialApp(
      title: 'responsivedashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}