import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/content_page.dart';
import '../../shared/widgets/info_banner.dart';
import '../../shared/widgets/markdown_view.dart';
import '../../shared/widgets/state_views.dart';

/// Shared scaffold for the markdown-backed pages (About, How to Use, dynamic
/// content). Handles loading/error/empty states and the English-fallback
/// warning banner.
class MarkdownPageScaffold extends ConsumerWidget {
  const MarkdownPageScaffold({
    super.key,
    required this.appBarTitle,
    required this.heroIcon,
    required this.content,
    required this.onRetry,
  });

  final String appBarTitle;
  final IconData heroIcon;
  final AsyncValue<MarkdownContent?> content;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: content.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorRetryView(
          message: 'Could not load this page.',
          onRetry: onRetry,
        ),
        data: (data) {
          if (data == null) {
            return const EmptyStateView(
              icon: Icons.article_outlined,
              title: 'Nothing here yet',
              subtitle: 'This page has no content for the selected language.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  Icon(heroIcon, color: context.scheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(data.title, style: context.text.displaySmall),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (data.isFallback) ...[
                const InfoBanner(
                  message:
                      'Showing the English version — this page is not yet '
                      'available in your selected language.',
                  kind: BannerKind.warning,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              MarkdownView(data.markdown),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}
