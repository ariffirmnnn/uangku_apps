import 'package:flutter/material.dart';
import 'login.dart';
import 'create.dart';
import 'dashboard.dart';
import 'setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UANGKU',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Halaman pertama adalah login
      routes: {
        '/login': (context) => const LoginPage(),
        '/create': (context) => const CreateAccountPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
