import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_links.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/link_launcher.dart';
import '../../providers/core_providers.dart';

/// The full navigation menu — mirrors the web app's header dropdowns + footer
/// (every destination the bottom nav doesn't cover).
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = context.scheme;
    final isMock = ref.watch(isMockModeProvider);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _Header(),
            if (isMock)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Demo mode — showing sample data',
                  style: context.text.bodySmall
                      ?.copyWith(color: context.colors.textMuted),
                ),
              ),
            _NavTile(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () => _go(context, AppRoutes.home),
            ),
            const Divider(),
            _SectionLabel('College Predictor'),
            _NavTile(
              icon: Icons.calculate_outlined,
              label: 'JoSAA Predictor',
              onTap: () => _go(context, AppRoutes.josaaPredictor),
            ),
            _NavTile(
              icon: Icons.calculate_outlined,
              label: 'CSAB Predictor',
              onTap: () => _go(context, AppRoutes.csabPredictor),
            ),
            const Divider(),
            _SectionLabel('Documents & Guides'),
            _NavTile(
              icon: Icons.description_outlined,
              label: 'JoSAA Documents',
              onTap: () => _go(context, AppRoutes.josaaDocuments),
            ),
            _NavTile(
              icon: Icons.open_in_new,
              label: 'CSAB Documents',
              trailing: const Icon(Icons.north_east, size: 16),
              onTap: () {
                Navigator.of(context).pop();
                LinkLauncher.open(context, AppLinks.csabDocumentsDrive);
              },
            ),
            _NavTile(
              icon: Icons.list_alt_outlined,
              label: 'Preference Guides',
              onTap: () => _go(context, AppRoutes.preferenceGuides),
            ),
            _NavTile(
              icon: Icons.help_outline,
              label: 'FAQs & Guides',
              onTap: () => _go(context, AppRoutes.faqs),
            ),
            _NavTile(
              icon: Icons.menu_book_outlined,
              label: 'How to Use',
              onTap: () => _go(context, AppRoutes.howToUse),
            ),
            const Divider(),
            _SectionLabel('Community'),
            _NavTile(
              icon: Icons.people_outline,
              label: 'Mentors',
              onTap: () => _go(context, AppRoutes.mentors),
            ),
            _NavTile(
              icon: Icons.shopping_bag_outlined,
              label: 'Merchandise',
              onTap: () => _go(context, AppRoutes.merchandise),
            ),
            const Divider(),
            _NavTile(
              icon: Icons.info_outline,
              label: 'About Us',
              onTap: () => _go(context, AppRoutes.aboutUs),
            ),
            _NavTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _go(context, AppRoutes.settings),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                '© Guruvela. All rights reserved.',
                style: context.text.bodySmall?.copyWith(color: scheme.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: const Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppConstants.appName,
            style: context.text.headlineMedium?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: context.text.labelSmall?.copyWith(color: context.colors.textMuted),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colors.textSecondary),
      title: Text(label, style: context.text.titleMedium),
      trailing: trailing,
      onTap: onTap,
      dense: true,
    );
  }
}
