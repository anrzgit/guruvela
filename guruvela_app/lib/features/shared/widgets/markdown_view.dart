import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/link_launcher.dart';

/// Renders markdown content with theme-aware styling and tappable links.
/// Used by About, How to Use and dynamic content pages.
class MarkdownView extends StatelessWidget {
  const MarkdownView(this.data, {super.key, this.selectable = true});

  final String data;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colors;
    final scheme = context.scheme;
    return MarkdownBody(
      data: data,
      selectable: selectable,
      onTapLink: (txt, href, title) {
        if (href != null) LinkLauncher.open(context, href);
      },
      styleSheet: MarkdownStyleSheet(
        p: text.bodyLarge,
        h1: text.displaySmall,
        h2: text.headlineMedium,
        h3: text.headlineSmall,
        h4: text.titleLarge,
        listBullet: text.bodyLarge,
        a: text.bodyLarge?.copyWith(
          color: colors.accent,
          decoration: TextDecoration.underline,
        ),
        strong: text.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        em: text.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
        blockquote: text.bodyMedium?.copyWith(color: colors.textMuted),
        blockquoteDecoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border(
            left: BorderSide(color: scheme.primary, width: 3),
          ),
        ),
        code: text.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: scheme.surfaceContainerHighest,
        ),
        codeblockDecoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        tableBorder: TableBorder.all(color: colors.border),
        tableHead: text.titleSmall,
        tableBody: text.bodyMedium,
      ),
    );
  }
}
