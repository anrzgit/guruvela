import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/mentor.dart';
import '../../../providers/core_providers.dart';

/// All active mentors (Mentors screen).
final mentorsProvider = FutureProvider.autoDispose<List<Mentor>>((ref) {
  return ref.watch(contentRepositoryProvider).fetchMentors();
});

/// First 4 mentors for the home-page preview.
final featuredMentorsProvider =
    FutureProvider.autoDispose<List<Mentor>>((ref) {
  return ref.watch(contentRepositoryProvider).fetchMentors(limit: 4);
});
