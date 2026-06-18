import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_links.dart';
import '../../../core/i18n/app_language.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../shared/widgets/app_card.dart';

/// "More" tab: appearance, language, navigation shortcuts, and links.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // ---- Appearance ----
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appearance', style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('Auto'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (s) =>
                      ref.read(themeModeProvider.notifier).setMode(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ---- Language ----
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Language', style: context.text.titleLarge),
                  ),
                ),
                RadioGroup<AppLanguage>(
                  groupValue: language,
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(languageProvider.notifier).setLanguage(v);
                    }
                  },
                  child: Column(
                    children: [
                      for (final lang in AppLanguage.values)
                        RadioListTile<AppLanguage>(
                          value: lang,
                          title: Text(lang.label),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ---- Shortcuts ----
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Tile(
                  icon: Icons.calculate_outlined,
                  label: 'CSAB Predictor',
                  onTap: () => context.push(AppRoutes.csabPredictor),
                ),
                _Tile(
                  icon: Icons.list_alt_outlined,
                  label: 'Preference Guides',
                  onTap: () => context.push(AppRoutes.preferenceGuides),
                ),
                _Tile(
                  icon: Icons.help_outline,
                  label: 'FAQs & Guides',
                  onTap: () => context.push(AppRoutes.faqs),
                ),
                _Tile(
                  icon: Icons.menu_book_outlined,
                  label: 'How to Use',
                  onTap: () => context.push(AppRoutes.howToUse),
                ),
                _Tile(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Merchandise',
                  onTap: () => context.push(AppRoutes.merchandise),
                ),
                _Tile(
                  icon: Icons.info_outline,
                  label: 'About Us',
                  onTap: () => context.push(AppRoutes.aboutUs),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ---- Community ----
          AppCard(
            padding: EdgeInsets.zero,
            child: _Tile(
              icon: Icons.chat_bubble_outline,
              label: 'Join WhatsApp Community',
              trailing: const Icon(Icons.north_east, size: 16),
              onTap: () =>
                  LinkLauncher.open(context, AppLinks.whatsappCommunity),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              '${AppConstants.appName} • v1.0.0',
              style: context.text.bodySmall
                  ?.copyWith(color: context.colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
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
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
