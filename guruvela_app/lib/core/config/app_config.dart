/// Centralized runtime configuration sourced from `--dart-define` values.
///
/// Mirrors the web app's `.env` (VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY,
/// VITE_GEMINI_API_KEY). Keys are NOT hardcoded here — pass them at build/run
/// time via a gitignored `env.json` (see `env.example.json`):
///
/// ```
/// flutter run   --dart-define-from-file=env.json
/// flutter build appbundle --release --dart-define-from-file=env.json
/// ```
///
/// When keys are absent the app falls back to mock repositories so it still
/// runs end-to-end offline (see `useMockData`).
abstract final class AppConfig {
  AppConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Force mock data even if real keys are present (handy for demos/tests).
  static const bool forceMockData = bool.fromEnvironment(
    'FORCE_MOCK',
    defaultValue: false,
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;

  /// True when we should serve mock data: either explicitly forced, or no
  /// Supabase credentials were provided.
  static bool get useMockData => forceMockData || !isSupabaseConfigured;
}
