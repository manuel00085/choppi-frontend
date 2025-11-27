import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_notifier.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/pages/auth_gate.dart';

// IMPORTS DE STORES
import 'features/stores/bloc/stores_cubit.dart';
import 'features/stores/data/store_repository.dart';
import 'features/stores/pages/stores_page.dart';

// IMPORT DE LOGIN (aún no lo usamos aquí)
import 'features/auth/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await SecureStorage.readToken();
  print("TOKEN ACTUAL: $token");

  runApp(const ChoppiApp());
}

class ChoppiApp extends StatelessWidget {
  const ChoppiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choppi App',
      debugShowCheckedModeBanner: false,

      // ⬇️ Notificaciones globales
      scaffoldMessengerKey: AppNotifier.messengerKey,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // ⬇️ Página Stores con BlocProvider
    home: const AuthGate(),
    );
  }
}
