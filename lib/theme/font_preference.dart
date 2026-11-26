import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class FontPreference extends ChangeNotifier {
  static const _preferenceKey = 'writing_style';

  AppFontStyle style = AppFontStyle.legible;
  bool loading = true;
  String? error;

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedStyle = preferences.getString(_preferenceKey);
      if (savedStyle != null) {
        style = AppFontStyle.values.firstWhere(
          (candidate) => candidate.name == savedStyle,
          orElse: () => throw FormatException('Estilo de fonte inválido.'),
        );
      }
    } on Exception catch (exception) {
      error = 'Não foi possível carregar a preferência de fonte: $exception';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> update(AppFontStyle value) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(_preferenceKey, value.name);
      if (!saved) {
        throw Exception('A preferência de fonte não foi salva.');
      }
      style = value;
      error = null;
      notifyListeners();
    } on Exception catch (exception) {
      error = 'Não foi possível salvar a preferência de fonte: $exception';
      notifyListeners();
      rethrow;
    }
  }
}
