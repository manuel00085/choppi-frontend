import 'package:flutter/material.dart';
import '../data/auth_api.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/app_notifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;

  final api = AuthApi(); // instancia del API

  Future<void> doLogin() async {
    setState(() => loading = true);

    try {
      final token =
          await api.login(emailCtrl.text.trim(), passwordCtrl.text.trim());

      await SecureStorage.saveToken(token);

       AppNotifier.showSuccess("Bienvenido");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login exitoso")),
      );

      Navigator.pushReplacementNamed(context, "/stores");

    } catch (e) {

       //AppNotifier.showError("Credenciales incorrectas");
    }

    setState(() => loading = false);
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
              onPressed: loading ? null : doLogin,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Ingresar"),
            )
          ],
        ),
      ),
    );
  }
}
