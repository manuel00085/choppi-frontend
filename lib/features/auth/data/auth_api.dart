import '../../../core/dio/dio_client.dart';

class AuthApi {
  final dio = DioClient.instance;

  Future<String> login(String email, String password) async {
    final res = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return res.data['access_token'];
  }
}
