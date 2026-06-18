import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/content_providers.dart';
import '../widgets/markdown_page_scaffold.dart';

class HowToUseScreen extends ConsumerWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MarkdownPageScaffold(
      appBarTitle: 'How to Use',
      heroIcon: Icons.menu_book_outlined,
      content: ref.watch(howToUseProvider),
      onRetry: () => ref.invalidate(howToUseProvider),
    );
  }
}
