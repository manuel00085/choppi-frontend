import 'package:flutter/material.dart';
import 'core/app_notifier.dart';
import 'features/auth/pages/auth_gate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cart/bloc/cart_cubit.dart';



void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: const ChoppiApp(),
    ),
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 153, 255)),
        useMaterial3: true,
      ),

      // ⬇️ Página Stores con BlocProvider
    home: const AuthGate(),
    );
  }
}
