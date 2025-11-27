import 'package:dio/dio.dart';
import '../app_notifier.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: "https://choppi-backend-production-4818.up.railway.app",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Leer token y ponerlo en headers
          final token = await SecureStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        // MANEJO GLOBAL DE ERRORES
        onError: (DioException error, handler) {
          String message = "Error inesperado";

          // Timeout
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            message = "Tiempo agotado. Revisa tu conexión.";
          }

          // Errores con respuesta del backend
          else if (error.response != null) {
            final data = error.response?.data;

            if (data is Map && data.containsKey('message')) {
              message = data['message'].toString();
            } else {
              message =
                  "Error del servidor (${error.response!.statusCode})";
            }

            // Manejo de token inválido
            if (error.response?.statusCode == 401) {
             // AppNotifier.showError("Sesión expirada. Inicia sesión de nuevo.");
              SecureStorage.clearToken();
            }
          }

          // Notificación global
          AppNotifier.showError(message);

          return handler.next(error);
        },
      ),
    );
}
