import 'package:flutter/material.dart';
import 'features/auth/pages/login_page.dart';
import 'core/app_notifier.dart';

void main() {
  runApp(const ChoppiApp());
}

class ChoppiApp extends StatelessWidget {
  const ChoppiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choppi App',
      debugShowCheckedModeBanner: false,

      // ⬇️ IMPORTANTE: agregar esto ⬇️
      scaffoldMessengerKey: AppNotifier.messengerKey,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
