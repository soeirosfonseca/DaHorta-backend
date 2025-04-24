import 'package:dahorta_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'providers/auth_provider.dart';
import 'providers/UserProvider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // 👈 aqui
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaHorta App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }

  void main() {
    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
        child: const MyApp(),
      ),
    );
  }
}
