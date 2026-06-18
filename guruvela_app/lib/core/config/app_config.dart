/// Centralized runtime configuration sourced from `--dart-define` values.
///
/// Mirrors the web app's `.env` (VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY,
/// VITE_GEMINI_API_KEY). Pass these at build/run time, e.g.:
///
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=ey... \
///   --dart-define=GEMINI_API_KEY=AIza...
/// ```
///
/// When keys are absent the app falls back to mock repositories so it still
/// runs end-to-end offline (see `useMockData`).
abstract final class AppConfig {
  AppConfig._();

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://acaoqrybztxymacdzyzf.supabase.co');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjYW9xcnlienR4eW1hY2R6eXpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4MTcyNzcsImV4cCI6MjA2MzM5MzI3N30.Z6heALQ8p-3881uM28tXR5yTzl7UB0y_5yUj8-TPZm0');

  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  /// Force mock data even if real keys are present (handy for demos/tests).
  static const bool forceMockData =
      bool.fromEnvironment('FORCE_MOCK', defaultValue: false);

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;

  /// True when we should serve mock data: either explicitly forced, or no
  /// Supabase credentials were provided.
  static bool get useMockData => forceMockData || !isSupabaseConfigured;
}
