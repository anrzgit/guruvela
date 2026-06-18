import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../data/models/document_item.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/info_banner.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/state_views.dart';
import '../view_models/content_providers.dart';

/// JoSAA documents list — port of `JosaaDocumentsPage.jsx`.
class JosaaDocumentsScreen extends ConsumerWidget {
  const JosaaDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(josaaDocumentsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('JoSAA Documents')),
      body: docs.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorRetryView(
          message: 'Could not load documents.',
          onRetry: () => ref.invalidate(josaaDocumentsProvider),
        ),
        data: (items) => ListView(
          padding: EdgeInsets.zero,
          children: [
            const PageHero(
              title: 'JoSAA Official Documents',
              subtitle: 'Reference documents from the official JoSAA portal.',
              icon: Icons.description_outlined,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const InfoBanner(
                    message:
                        'All documents are sourced from the official JoSAA '
                        'website. Always verify on the official portal.',
                    kind: BannerKind.warning,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final doc in items) ...[
                    _DocTile(doc: doc),
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

class _DocTile extends StatelessWidget {
  const _DocTile({required this.doc});
  final DocumentItem doc;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.title, style: context.text.titleMedium),
                if (doc.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(doc.description, style: context.text.bodySmall),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: () => LinkLauncher.open(context, doc.link),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('View'),
          ),
        ],
      ),
    );
  }
}
