import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'providers/core_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  debugPrint('[main] supabaseUrl: "${AppConfig.supabaseUrl}"');
  debugPrint('[main] isSupabaseConfigured: ${AppConfig.isSupabaseConfigured}');
  debugPrint('[main] useMockData: ${AppConfig.useMockData}');

  // Initialize Supabase only when real credentials were provided via
  // --dart-define. Otherwise the app runs entirely on mock repositories.
  if (AppConfig.isSupabaseConfigured && !AppConfig.forceMockData) {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // The Supabase anon key is the public/publishable client key.
        publishableKey: AppConfig.supabaseAnonKey,
      );
      debugPrint('[main] Supabase initialized OK');
    } catch (e, st) {
      debugPrint('[main] Supabase init FAILED: $e');
      debugPrint('[main] $st');
    }
  } else {
    debugPrint('[main] Skipping Supabase init — running in MOCK mode');
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const GuruvelaApp(),
    ),
  );
}
