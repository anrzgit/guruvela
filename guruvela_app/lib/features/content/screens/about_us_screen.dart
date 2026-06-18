import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/content_providers.dart';
import '../widgets/markdown_page_scaffold.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownPageScaffold(
      appBarTitle: 'About Us',
      heroIcon: Icons.info_outline,
      content: ref.watch(aboutUsProvider),
      onRetry: () => ref.invalidate(aboutUsProvider),
    );
  }
}
