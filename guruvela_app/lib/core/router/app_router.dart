import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chatbot/screens/chat_screen.dart';
import '../../features/content/screens/about_us_screen.dart';
import '../../features/content/screens/content_page_screen.dart';
import '../../features/content/screens/faqs_screen.dart';
import '../../features/content/screens/how_to_use_screen.dart';
import '../../features/content/screens/josaa_documents_screen.dart';
import '../../features/content/screens/merchandise_screen.dart';
import '../../features/content/screens/preference_guides_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/mentors/screens/mentors_screen.dart';
import '../../features/predictor/screens/csab_predictor_screen.dart';
import '../../features/predictor/screens/josaa_predictor_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import '../constants/app_constants.dart';

/// Central go_router configuration.
///
/// A [StatefulShellRoute] hosts the four primary tabs (Home, Predictor,
/// Mentors, More) behind a persistent bottom navigation bar; secondary pages
/// (content, CSAB, settings, chat) are pushed on top.
final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => AppShell(navigationShell: navShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.josaaPredictor,
                name: 'josaa',
                builder: (context, state) => const JosaaPredictorScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mentors,
                name: 'mentors',
                builder: (context, state) => const MentorsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'more',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ---- Secondary routes (pushed over the shell) ----
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.csabPredictor,
        name: 'csab',
        builder: (context, state) => const CsabPredictorScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.aboutUs,
        name: 'about',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.howToUse,
        name: 'how-to-use',
        builder: (context, state) => const HowToUseScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.faqs,
        name: 'faqs',
        builder: (context, state) => const FaqsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.josaaDocuments,
        name: 'josaa-documents',
        builder: (context, state) => const JosaaDocumentsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.preferenceGuides,
        name: 'preference-guides',
        builder: (context, state) => const PreferenceGuidesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.merchandise,
        name: 'merchandise',
        builder: (context, state) => const MerchandiseScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: AppRoutes.contentPagePattern,
        name: 'content-page',
        builder: (context, state) =>
            ContentPageScreen(slug: state.pathParameters['slug']!),
      ),
    ],
  );
}
