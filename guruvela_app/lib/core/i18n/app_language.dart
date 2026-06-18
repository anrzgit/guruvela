/// The three languages supported by Guruvela (matches the web app).
///
/// `hi-en` is Hinglish (Hindi in Latin script) and `te-en` is Tenglish
/// (Telugu in Latin script). These codes are also the values stored in the
/// database `language`/`language_code` columns and sent to Gemini.
enum AppLanguage {
  english('en', 'English'),
  hinglish('hi-en', 'Hinglish'),
  tenglish('te-en', 'Teluguish');

  const AppLanguage(this.code, this.label);

  /// The DB/storage code, e.g. `en`, `hi-en`, `te-en`.
  final String code;

  /// Human-readable label shown in the language selector.
  final String label;

  /// Language name used inside the Gemini prompt.
  String get geminiName => switch (this) {
        AppLanguage.english => 'English',
        AppLanguage.hinglish => 'Hinglish (Hindi in Latin script)',
        AppLanguage.tenglish => 'Tenglish (Telugu in Latin script)',
      };

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
