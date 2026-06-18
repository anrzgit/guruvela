import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/mentor.dart';
import '../../../providers/core_providers.dart';

/// All active mentors (Mentors screen).
final mentorsProvider = FutureProvider.autoDispose<List<Mentor>>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final isMock = ref.watch(isMockModeProvider);
  debugPrint('[MentorsProvider] using ${isMock ? "MOCK" : "SUPABASE"} repo');
  try {
    final list = await repo.fetchMentors();
    debugPrint('[MentorsProvider] fetched ${list.length} mentors');
    return list;
  } catch (e, st) {
    debugPrint('[MentorsProvider] ERROR: $e');
    debugPrint('[MentorsProvider] stacktrace: $st');
    rethrow;
  }
});

/// First 4 mentors for the home-page preview.
final featuredMentorsProvider =
    FutureProvider.autoDispose<List<Mentor>>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final isMock = ref.watch(isMockModeProvider);
  debugPrint('[FeaturedMentors] using ${isMock ? "MOCK" : "SUPABASE"} repo');
  try {
    final list = await repo.fetchMentors(limit: 4);
    debugPrint('[FeaturedMentors] fetched ${list.length} mentors');
    return list;
  } catch (e, st) {
    debugPrint('[FeaturedMentors] ERROR: $e');
    debugPrint('[FeaturedMentors] stacktrace: $st');
    rethrow;
  }
});
