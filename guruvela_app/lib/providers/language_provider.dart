import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/i18n/app_language.dart';
import '../core/i18n/app_strings.dart';
import 'core_providers.dart';

/// Holds the selected [AppLanguage] and persists it (key `guruvela-lang`,
/// matching the web app's localStorage key).
class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppLanguage.fromCode(prefs.getString(AppConstants.prefLanguage));
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefLanguage, language.code);
  }
}

final languageProvider =
    NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);

/// Strings bundle bound to the current language.
final stringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(languageProvider));
});
