import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage storage;
  Future<void> _pending = Future.value();
  SecureTokenStorage({this.storage = const FlutterSecureStorage()});
  // Serializa operações para impedir que uma gravação antiga vença o logout.
  Future<T> _queue<T>(Future<T> Function() action) {
    final result = _pending.then((_) => action());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  @override
  Future<String?> read() =>
      _queue(() => storage.read(key: 'tasklab_access_token'));
  @override
  Future<void> write(String token) =>
      _queue(() => storage.write(key: 'tasklab_access_token', value: token));
  @override
  Future<void> delete() =>
      _queue(() => storage.delete(key: 'tasklab_access_token'));
}
