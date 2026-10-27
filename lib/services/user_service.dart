import '../config/app_config.dart';
import '../exceptions/api_exception.dart';
import '../models/user.dart';
import 'api_client.dart';

class UserService {
  final ApiClient api;
  UserService(this.api);
  Future<User> me() async =>
      User.fromJson(await api.request('GET', '/users/me'));
  Future<User> update(String name, String email) async {
    if (!AppConfig.profileEditingAvailable) {
      throw const ApiException(
        'A API ainda não oferece edição de nome e e-mail.',
      );
    }
    // Contrato proposto, desabilitado até confirmação do backend.
    return User.fromJson(
      await api.request(
        'PATCH',
        '/users/me',
        data: {'name': name.trim(), 'email': email.trim()},
      ),
    );
  }

  Future<void> changePassword(String current, String next) async {
    await api.request(
      'PATCH',
      '/users/me/password',
      data: {'current_password': current, 'new_password': next},
    );
  }
}
