import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../models/content_page.dart';
import '../models/document_item.dart';
import '../models/mentor.dart';
import 'content_repository.dart';

/// Supabase-backed CMS reads. Table/column names match the web app.
class SupabaseContentRepository implements ContentRepository {
  SupabaseContentRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Mentor>> fetchMentors({int? limit}) async {
    debugPrint('[SupabaseRepo] fetchMentors(limit: $limit) — '
        'table: "${SupabaseTables.mentors}"');
    var builder = _client
        .from(SupabaseTables.mentors)
        .select(
          'id, name, profile_image_path, branch, state, '
          'google_form_link_1_to_1, group_guidance_link, linkedin_url, '
          'active, sort_order',
        )
        .eq('active', true)
        .order('sort_order', ascending: true);
    if (limit != null) builder = builder.limit(limit);

    debugPrint('[SupabaseRepo] executing query...');
    final data = await builder.timeout(
      const Duration(seconds: 15),
      onTimeout: () =>
          throw TimeoutException('Supabase mentors query timed out after 15s'),
    );
    debugPrint('[SupabaseRepo] raw rows: ${data.length}');
    return data.cast<Map<String, dynamic>>().map(Mentor.fromMap).toList();
  }

  /// Resolves the public URL for a mentor's profile image, or the DiceBear
  /// fallback. Kept here so widgets stay backend-agnostic.
  String mentorImageUrl(Mentor mentor) {
    final path = mentor.profileImagePath;
    if (path == null || path.isEmpty) return '';
    return _client.storage.from(AppLinksBucket.profilePic).getPublicUrl(path);
  }

  @override
  Future<MarkdownContent?> fetchStaticPage(
    String identifier,
    String languageCode,
  ) async {
    Future<Map<String, dynamic>?> query(String lang) async {
      final rows = await _client
          .from(SupabaseTables.staticPageContent)
          .select('title, content_markdown, language_code')
          .eq('page_identifier', identifier)
          .eq('language_code', lang)
          .limit(1);
      return rows.isEmpty ? null : rows.first;
    }

    return _withFallback(query, languageCode);
  }

  @override
  Future<MarkdownContent?> fetchHowToUse(String languageCode) async {
    Future<Map<String, dynamic>?> query(String lang) async {
      final rows = await _client
          .from(SupabaseTables.howToUseTranslations)
          .select('title, content_markdown, language_code')
          .eq('language_code', lang)
          .limit(1);
      return rows.isEmpty ? null : rows.first;
    }

    return _withFallback(query, languageCode);
  }

  @override
  Future<List<ContentPageSummary>> fetchContentIndex(
    String languageCode,
  ) async {
    final data = await _client
        .from(SupabaseTables.contentPages)
        .select('title, slug, page_type, language')
        .inFilter('page_type', ['faq', 'guide'])
        .eq('language', languageCode)
        .order('title', ascending: true);

    final list =
        data.cast<Map<String, dynamic>>().map(ContentPageSummary.fromMap);
    // De-dupe by slug (a slug can exist in multiple languages).
    final seen = <String>{};
    return [
      for (final item in list)
        if (seen.add(item.slug)) item,
    ];
  }

  @override
  Future<MarkdownContent?> fetchContentBySlug(
    String slug,
    String languageCode,
  ) async {
    Future<Map<String, dynamic>?> query(String lang) async {
      final rows = await _client
          .from(SupabaseTables.contentPages)
          .select('title, content_markdown, language, page_type')
          .eq('slug', slug)
          .eq('language', lang)
          .limit(1);
      return rows.isEmpty ? null : rows.first;
    }

    return _withFallback(query, languageCode);
  }

  @override
  Future<List<DocumentItem>> fetchDocuments(String category) async {
    final data = await _client
        .from(SupabaseTables.document)
        .select('id, title, description, link, category')
        .eq('category', category);
    return data.cast<Map<String, dynamic>>().map(DocumentItem.fromMap).toList();
  }

  /// Runs [query] for the requested language, falling back to English and
  /// tagging the result as a fallback so the UI can warn the user.
  Future<MarkdownContent?> _withFallback(
    Future<Map<String, dynamic>?> Function(String lang) query,
    String languageCode,
  ) async {
    var row = await query(languageCode);
    var isFallback = false;
    var served = languageCode;
    if (row == null && languageCode != 'en') {
      row = await query('en');
      isFallback = row != null;
      served = 'en';
    }
    if (row == null) return null;
    return MarkdownContent(
      title: (row['title'] ?? '') as String,
      markdown: (row['content_markdown'] ?? '') as String,
      servedLanguage: served,
      isFallback: isFallback,
    );
  }
}

/// Local alias so this file doesn't need to import the links constants just
/// for one bucket name.
abstract final class AppLinksBucket {
  static const String profilePic = 'profilepic';
}
