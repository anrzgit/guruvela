import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/content_page.dart';
import '../../../data/models/document_item.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/language_provider.dart';

/// About Us markdown (identifier `about-us`).
final aboutUsProvider = FutureProvider.autoDispose<MarkdownContent?>((ref) {
  final lang = ref.watch(languageProvider);
  return ref
      .watch(contentRepositoryProvider)
      .fetchStaticPage('about-us', lang.code);
});

/// How to Use markdown.
final howToUseProvider = FutureProvider.autoDispose<MarkdownContent?>((ref) {
  final lang = ref.watch(languageProvider);
  return ref.watch(contentRepositoryProvider).fetchHowToUse(lang.code);
});

/// FAQ + guide index.
final contentIndexProvider =
    FutureProvider.autoDispose<List<ContentPageSummary>>((ref) {
  final lang = ref.watch(languageProvider);
  return ref.watch(contentRepositoryProvider).fetchContentIndex(lang.code);
});

/// A single dynamic content page, keyed by slug.
final contentBySlugProvider = FutureProvider.autoDispose
    .family<MarkdownContent?, String>((ref, slug) {
  final lang = ref.watch(languageProvider);
  return ref
      .watch(contentRepositoryProvider)
      .fetchContentBySlug(slug, lang.code);
});

/// JoSAA documents.
final josaaDocumentsProvider =
    FutureProvider.autoDispose<List<DocumentItem>>((ref) {
  return ref.watch(contentRepositoryProvider).fetchDocuments('JoSAA');
});
