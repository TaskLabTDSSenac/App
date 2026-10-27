import 'api_client.dart';
import '../exceptions/api_exception.dart';

class AuthService {
  final ApiClient api;
  AuthService(this.api);
  Future<String> login(String email, String password) async {
    final data = await api.request(
      'POST',
      '/auth/login',
      authenticated: false,
      data: {'email': email.trim(), 'password': password},
    );
    if (data is! Map ||
        data['access_token'] is! String ||
        data['access_token'].isEmpty ||
        data['token_type'] != 'bearer') {
      throw const ApiException('A API não retornou uma sessão válida.');
    }
    return data['access_token'];
  }

  Future<void> register(String name, String email, String password) async {
    await api.request(
      'POST',
      '/auth/register',
      authenticated: false,
      data: {'name': name.trim(), 'email': email.trim(), 'password': password},
    );
  }
}
