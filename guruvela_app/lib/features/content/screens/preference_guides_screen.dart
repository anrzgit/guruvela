import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/static_data/preference_guides_data.dart';
import '../../../providers/language_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/info_banner.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/whatsapp_button.dart';

/// Preference guides — port of `PreferenceGuidesPage.jsx` (static, localized).
class PreferenceGuidesScreen extends ConsumerWidget {
  const PreferenceGuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final guides = PreferenceGuidesData.forLanguage(lang);
    return Scaffold(
      appBar: AppBar(title: const Text('Preference Guides')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PageHero(
            title: 'College Preference Guides',
            subtitle:
                'Curated preference orders to help you fill your choice list.',
            icon: Icons.list_alt_outlined,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const InfoBanner(
                  message:
                      'Join our WhatsApp community directly to get the detailed '
                      'preference lists.',
                ),
                const SizedBox(height: AppSpacing.md),
                for (final guide in guides) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guide.title, style: context.text.titleLarge),
                        const SizedBox(height: AppSpacing.sm),
                        Text(guide.description, style: context.text.bodyMedium),
                        const SizedBox(height: AppSpacing.md),
                        const WhatsappButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
