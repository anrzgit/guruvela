import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/content_providers.dart';
import '../widgets/markdown_page_scaffold.dart';

/// Dynamic content page reached via `/pages/:slug` (FAQ / guide articles).
class ContentPageScreen extends ConsumerWidget {
  const ContentPageScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownPageScaffold(
      appBarTitle: 'Guide',
      heroIcon: Icons.article_outlined,
      content: ref.watch(contentBySlugProvider(slug)),
      onRetry: () => ref.invalidate(contentBySlugProvider(slug)),
    );
  }
}
