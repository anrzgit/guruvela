import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';

/// A canned answer returned for a topic chip / keyword match.
class FixedResponse {
  const FixedResponse({
    required this.answer,
    this.relatedSlug,
    this.showHowToUse = false,
  });

  final String answer;
  final String? relatedSlug;
  final bool showHowToUse;
}

/// Looks up pre-written chatbot answers (`fixed_responses` table) and supplies
/// the topic-chip example queries. Implemented by Supabase + Mock.
abstract interface class ChatRepository {
  /// Resolve a fixed response for a tapped topic chip, identified by [topicId].
  /// Falls back to English when [languageCode] has no entry.
  Future<FixedResponse?> fetchFixedResponse(
    String topicId,
    String languageCode,
  );
}

class SupabaseChatRepository implements ChatRepository {
  SupabaseChatRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<FixedResponse?> fetchFixedResponse(
    String topicId,
    String languageCode,
  ) async {
    Future<Map<String, dynamic>?> query(String lang) async {
      final rows = await _client
          .from(SupabaseTables.fixedResponses)
          .select('answer_text, related_content_slug')
          .eq('topic_id', topicId)
          .eq('language', lang)
          .limit(1);
      return rows.isEmpty ? null : rows.first;
    }

    var row = await query(languageCode);
    var fallbackNote = '';
    if (row == null && languageCode != 'en') {
      row = await query('en');
      if (row != null) {
        fallbackNote =
            ' (Showing English result as specific content for your selected '
            'language was not found.)';
      }
    }
    if (row == null) return null;
    final slug = row['related_content_slug'] as String?;
    return FixedResponse(
      answer: '${row['answer_text']}$fallbackNote',
      relatedSlug: slug,
      showHowToUse: slug == 'josaa-comprehensive-faq',
    );
  }
}

/// Offline canned answers for the four built-in topics.
class MockChatRepository implements ChatRepository {
  const MockChatRepository();

  static const _answers = <String, FixedResponse>{
    'josaa_documents_general': FixedResponse(
      answer:
          'For JoSAA you typically need: your JEE scorecard, Class X & XII '
          'certificates, a category certificate (if applicable), a PwD '
          'certificate (if applicable), photo ID, and recent photographs. '
          'Check the official documents list for the exact requirements.',
      relatedSlug: 'josaa-documents-required',
    ),
    'josaa_float_freeze_slide_meaning': FixedResponse(
      answer:
          'Freeze = accept and keep your seat; Float = accept but stay in the '
          'running for a better allotment; Slide = stay in the same institute '
          'but allow a better branch in later rounds.',
      relatedSlug: 'float-freeze-slide',
    ),
    'iit_preparatory_what_is': FixedResponse(
      answer:
          'A preparatory rank is a special category rank that lets eligible '
          'SC/ST/PwD candidates take a one-year preparatory course before '
          'joining the regular program.',
      relatedSlug: 'iit-preparatory-course',
    ),
    'josaa_colorblind_general': FixedResponse(
      answer:
          'Some branches have visual-fitness requirements. If you are '
          'colorblind, obtain the prescribed medical certificate and review '
          'which programs accept it before locking your choices.',
      relatedSlug: 'colorblindness-medical',
    ),
  };

  @override
  Future<FixedResponse?> fetchFixedResponse(
    String topicId,
    String languageCode,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _answers[topicId];
  }
}
