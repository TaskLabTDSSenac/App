import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklab_mobile/theme/app_theme.dart';
import 'package:tasklab_mobile/theme/font_preference.dart';

void main() {
  test('font preference is persisted and restored', () async {
    SharedPreferences.setMockInitialValues({});
    final preference = FontPreference();

    await preference.load();
    expect(preference.style, AppFontStyle.legible);
    expect(
      AppTheme.theme(fontStyle: AppFontStyle.manuscript)
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'TaskLabTitle',
    );

    await preference.update(AppFontStyle.manuscript);
    final restored = FontPreference();
    await restored.load();

    expect(restored.style, AppFontStyle.manuscript);
    preference.dispose();
    restored.dispose();
  });
}
