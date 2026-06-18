import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/mock_content_repository.dart';
import '../data/repositories/mock_predictor_repository.dart';
import '../data/repositories/predictor_repository.dart';
import '../data/repositories/supabase_content_repository.dart';
import '../data/repositories/supabase_predictor_repository.dart';
import '../data/services/gemini_service.dart';

/// SharedPreferences instance — overridden with the real value in `main()`
/// after `await SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// The Supabase client, or null when running on mock data.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (AppConfig.useMockData) return null;
  return Supabase.instance.client;
});

/// True when the app is serving mock (offline) data.
final isMockModeProvider = Provider<bool>((ref) => AppConfig.useMockData);

/// Predictor repository — Supabase when configured, otherwise mock.
final predictorRepositoryProvider = Provider<PredictorRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const MockPredictorRepository();
  return SupabasePredictorRepository(client);
});

/// Content/CMS repository — Supabase when configured, otherwise mock.
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const MockContentRepository();
  return SupabaseContentRepository(client);
});

/// Chat (fixed-response) repository — Supabase when configured, otherwise mock.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const MockChatRepository();
  return SupabaseChatRepository(client);
});

/// Gemini service singleton.
final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

/// Resolves a mentor's avatar URL appropriately for the active backend.
/// (Supabase storage public URL, or DiceBear fallback in mock mode.)
final mentorImageResolverProvider = Provider<String Function(String? path, String name)>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    return (path, name) =>
        'https://api.dicebear.com/7.x/initials/svg?seed=${Uri.encodeComponent(name)}&backgroundColor=0047AB&textColor=ffffff';
  }
  return (path, name) {
    if (path == null || path.isEmpty) {
      return 'https://api.dicebear.com/7.x/initials/svg?seed=${Uri.encodeComponent(name)}&backgroundColor=0047AB&textColor=ffffff';
    }
    return client.storage.from('profilepic').getPublicUrl(path);
  };
});
