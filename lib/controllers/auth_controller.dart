import 'package:flutter/foundation.dart';

import '../exceptions/api_exception.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/token_storage.dart';

enum AuthPhase { checking, signedOut, authenticated, unavailable }

class AuthController extends ChangeNotifier {
  final ApiClient api;
  final TokenStorage storage;
  late final AuthService auth = AuthService(api);
  late final UserService users = UserService(api);
  AuthPhase phase = AuthPhase.checking;
  User? user;
  String? message;
  bool busy = false;
  int _operation = 0;
  AuthController(this.api, this.storage) {
    api.onUnauthorized = () {
      logout(expired: true);
    };
  }

  Future<void> restore() async {
    final operation = ++_operation;
    phase = AuthPhase.checking;
    message = null;
    notifyListeners();
    try {
      final token = api.token ?? await storage.read();
      if (operation != _operation) return;
      if (token == null) {
        phase = AuthPhase.signedOut;
        notifyListeners();
        return;
      }
      if (api.token != token) api.token = token;
      final profile = await users.me();
      if (operation != _operation) return;
      user = profile;
      phase = AuthPhase.authenticated;
    } catch (error) {
      if (operation != _operation) return;
      phase = AuthPhase.unavailable;
      message = friendlyError(error);
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (busy) return;
    busy = true;
    message = null;
    final operation = ++_operation;
    notifyListeners();
    try {
      final token = await auth.login(email, password);
      if (operation != _operation) return;
      try {
        await storage.write(token);
      } catch (_) {
        throw const ApiException(
          'Não foi possível guardar a sessão com segurança. Tente novamente.',
        );
      }
      if (operation != _operation) return;
      api.token = token;
      await restore();
    } catch (error) {
      if (operation == _operation) {
        message = friendlyError(error);
        phase = AuthPhase.signedOut;
      }
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> logout({bool expired = false}) async {
    if (expired && api.token == null) return;
    final operation = ++_operation;
    api.token = null;
    user = null;
    busy = false;
    phase = AuthPhase.signedOut;
    message = expired ? 'Sua sessão expirou. Entre novamente.' : null;
    notifyListeners();
    try {
      await storage.delete();
    } catch (_) {
      if (operation == _operation) {
        message = 'A sessão foi encerrada em memória, mas não foi possível apagar o token salvo. Tente sair novamente antes de fechar o aplicativo.';
        notifyListeners();
      }
    }
  }

  Future<void> updateProfile(String name, String email) async {
    final version = api.generation;
    final updated = await users.update(name, email);
    if (version != api.generation) return;
    user = updated;
    notifyListeners();
  }
}

String friendlyError(Object error) => error is ApiException
    ? error.message
    : error is FormatException
    ? 'A API retornou dados inválidos. Tente novamente.'
    : 'Não foi possível acessar os dados ou o armazenamento seguro. Tente novamente.';
