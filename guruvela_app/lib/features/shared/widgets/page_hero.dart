import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The white hero band at the top of most content/predictor pages: an icon
/// chip, a big title, and a subtitle. Mirrors the web app's page headers.
class PageHero extends StatelessWidget {
  const PageHero({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Container(
      width: double.infinity,
      color: scheme.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(title, style: context.text.displayMedium),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: context.text.bodyLarge
                  ?.copyWith(color: context.colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// A small section title used inside cards/lists.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: context.text.headlineSmall)),
        ?action,
      ],
    );
  }
}
