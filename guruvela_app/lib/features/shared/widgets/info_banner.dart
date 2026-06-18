import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

enum BannerKind { info, warning, error, success }

/// Colored notice box (info / warning / error / success). Replaces the web
/// app's tinted `bg-yellow-50` / `bg-red-50` banners.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.kind = BannerKind.info,
    this.icon,
  });

  final String message;
  final BannerKind kind;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (base, defaultIcon) = switch (kind) {
      BannerKind.info => (colors.accent, Icons.info_outline),
      BannerKind.warning => (colors.warning, Icons.warning_amber_rounded),
      BannerKind.error => (colors.danger, Icons.error_outline),
      BannerKind.success => (colors.success, Icons.check_circle_outline),
    };
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: base.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, color: base, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: context.text.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
