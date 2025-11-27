import 'package:flutter/material.dart';
import 'dart:developer';
import '../../../core/storage/secure_storage.dart';
import '../../stores/pages/stores_page.dart';
import '../../auth/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../stores/data/store_repository.dart';
import '../../stores/bloc/stores_cubit.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? token;

  @override
  void initState() {
    super.initState();
    log("AuthGate: initState");
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    log("AuthGate: Revisando token...");
    final t = await SecureStorage.readToken();
    log("AuthGate: Token leído = $t");

    setState(() {
      token = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("AuthGate: build() ejecutado → token actual = $token");

    if (token == null) {
      log("AuthGate: Mostrando LoginPage");
      return const LoginPage();
    }

    log("AuthGate: Token encontrado → mostrando StoresPage");

    return BlocProvider(
      create: (_) => StoresCubit(StoreRepository()),
      child: const StoresPage(),
    );
  }
}
