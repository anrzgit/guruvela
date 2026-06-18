/// App-wide identifiers: route paths/names and Supabase table names.
abstract final class AppConstants {
  AppConstants._();

  static const String appName = 'Guruvela';
  static const String appTagline =
      'Your trusted guide for JoSAA, CSAB, and engineering admissions in India.';

  // SharedPreferences keys
  static const String prefThemeMode = 'guruvela-theme-mode';
  static const String prefLanguage = 'guruvela-lang';
}

/// Supabase table names referenced by the repositories (matches the web app).
abstract final class SupabaseTables {
  SupabaseTables._();

  static const String collegeCutoffs = 'college_cutoffs';
  static const String csabCollegeCutoffs = 'csab_college_cutoffs';
  static const String mentors = 'mentors';
  static const String staticPageContent = 'static_page_content';
  static const String howToUseTranslations = 'how_to_use_page_translations';
  static const String contentPages = 'content_pages';
  static const String document = 'document';
  static const String fixedResponses = 'fixed_responses';
}

/// Named routes / paths used with go_router.
abstract final class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String josaaPredictor = '/rank-predictor';
  static const String csabPredictor = '/csab-predictor';
  static const String mentors = '/mentors';
  static const String merchandise = '/merchandise';
  static const String preferenceGuides = '/preference-guides';
  static const String josaaDocuments = '/josaa-documents';
  static const String faqs = '/faqs';
  static const String howToUse = '/how-to-use';
  static const String aboutUs = '/about-us';
  static const String settings = '/settings';
  static const String chat = '/chat';

  /// Dynamic content page, e.g. `/pages/some-slug`.
  static String contentPage(String slug) => '/pages/$slug';
  static const String contentPagePattern = '/pages/:slug';
}
