import '../models/content_page.dart';
import '../models/document_item.dart';
import '../models/mentor.dart';

/// Contract for all CMS-style reads: mentors, markdown pages, FAQ index and
/// documents. Implemented by Supabase and Mock variants.
abstract interface class ContentRepository {
  /// Active mentors ordered by `sort_order`. [limit] caps the count (the home
  /// page preview fetches 4).
  Future<List<Mentor>> fetchMentors({int? limit});

  /// Static markdown page by identifier (e.g. `about-us`) with English
  /// fallback when the requested [languageCode] is missing.
  Future<MarkdownContent?> fetchStaticPage(
    String identifier,
    String languageCode,
  );

  /// "How to Use" page translation with English fallback.
  Future<MarkdownContent?> fetchHowToUse(String languageCode);

  /// Index of FAQ + guide pages.
  Future<List<ContentPageSummary>> fetchContentIndex(String languageCode);

  /// A single dynamic content page by slug, with English fallback.
  Future<MarkdownContent?> fetchContentBySlug(
    String slug,
    String languageCode,
  );

  /// Documents for a category (e.g. `JoSAA`).
  Future<List<DocumentItem>> fetchDocuments(String category);
}
