import 'package:equatable/equatable.dart';

/// Markdown content with the language it was actually served in, so screens
/// can show the "showing English fallback" banner when [servedLanguage]
/// differs from what was requested.
class MarkdownContent extends Equatable {
  const MarkdownContent({
    required this.title,
    required this.markdown,
    required this.servedLanguage,
    this.isFallback = false,
  });

  final String title;
  final String markdown;
  final String servedLanguage;
  final bool isFallback;

  MarkdownContent copyWith({bool? isFallback, String? servedLanguage}) {
    return MarkdownContent(
      title: title,
      markdown: markdown,
      servedLanguage: servedLanguage ?? this.servedLanguage,
      isFallback: isFallback ?? this.isFallback,
    );
  }

  @override
  List<Object?> get props => [title, markdown, servedLanguage, isFallback];
}

/// A list item in the FAQs/Guides index (`content_pages` table).
class ContentPageSummary extends Equatable {
  const ContentPageSummary({
    required this.title,
    required this.slug,
    required this.pageType,
  });

  final String title;
  final String slug;

  /// Either `faq` or `guide`.
  final String pageType;

  bool get isGuide => pageType == 'guide';

  factory ContentPageSummary.fromMap(Map<String, dynamic> map) {
    return ContentPageSummary(
      title: (map['title'] ?? '') as String,
      slug: (map['slug'] ?? '') as String,
      pageType: (map['page_type'] ?? 'faq') as String,
    );
  }

  @override
  List<Object?> get props => [title, slug, pageType];
}
