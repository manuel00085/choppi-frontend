import 'package:flutter/material.dart';
import '../data/auth_api.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/app_notifier.dart';
import 'auth_gate.dart';
import '../../../core/app_loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final api = AuthApi();

  Future<void> doLogin() async {
    final email = emailCtrl.text.trim();
    final pass = passwordCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      AppNotifier.showError("Debe llenar todos los campos");
      return;
    }

    AppLoading.show(context);

    try {
      final token = await api.login(email, pass);

      await SecureStorage.saveToken(token);
      AppNotifier.showSuccess("Bienvenido");

      if (!mounted) return;
      AppLoading.hide(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    } catch (e) {
      if (mounted) {
        AppLoading.hide(context);
        AppNotifier.showError("Credenciales inválidas");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: doLogin,
              child: const Text("Ingresar"),
            ),
          ],
        ),
      ),
    );
  }
}
