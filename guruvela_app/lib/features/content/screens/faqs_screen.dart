import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/content_page.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/state_views.dart';
import '../view_models/content_providers.dart';

/// FAQs & Guides index — port of `FAQListPage.jsx`.
class FaqsScreen extends ConsumerWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(contentIndexProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('FAQs & Guides')),
      body: index.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorRetryView(
          message: 'Could not load the knowledge base.',
          onRetry: () => ref.invalidate(contentIndexProvider),
        ),
        data: (items) => ListView(
          padding: EdgeInsets.zero,
          children: [
            const PageHero(
              title: 'Knowledge Base',
              subtitle: 'Browse our FAQs and step-by-step guides.',
              icon: Icons.help_outline,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  for (final item in items) ...[
                    _ContentTile(item: item),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentTile extends StatelessWidget {
  const _ContentTile({required this.item});
  final ContentPageSummary item;

  @override
  Widget build(BuildContext context) {
    final isGuide = item.isGuide;
    final accent = isGuide ? context.scheme.primary : context.colors.success;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => context.go(AppRoutes.contentPage(item.slug)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              isGuide ? Icons.description_outlined : Icons.help_outline,
              color: accent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(item.title, style: context.text.titleMedium),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              isGuide ? 'GUIDE' : 'FAQ',
              style: context.text.labelSmall?.copyWith(color: accent),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(Icons.chevron_right, color: context.colors.textMuted),
        ],
      ),
    );
  }
}
