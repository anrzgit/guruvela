import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';

/// Root widget. Holds the [GoRouter] for the app's lifetime and rebuilds
/// only the [MaterialApp.router] config when the theme mode changes.
class GuruvelaApp extends ConsumerStatefulWidget {
  const GuruvelaApp({super.key});

  @override
  ConsumerState<GuruvelaApp> createState() => _GuruvelaAppState();
}

class _GuruvelaAppState extends ConsumerState<GuruvelaApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
