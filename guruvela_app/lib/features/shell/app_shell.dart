import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import 'app_drawer.dart';

/// Hosts the four primary tabs behind a [NavigationBar] and exposes the full
/// menu via the [AppDrawer]. A floating chat button is shown on every tab
/// except the chat screen itself (which is a pushed route).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Tapping the active tab pops to its root.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      drawer: const AppDrawer(),
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        heroTag: 'chat-fab',
        onPressed: () => context.push(AppRoutes.chat),
        backgroundColor: context.scheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.forum_outlined),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: s.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: s.navPredictor,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: s.navMentors,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu),
            selectedIcon: const Icon(Icons.menu_open),
            label: s.navMore,
          ),
        ],
      ),
    );
  }
}

/// Shared app bar used by the tab screens: shows a menu button that opens the
/// shell drawer, the title, and a quick theme toggle.
class GuruvelaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GuruvelaAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }
}
