import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// A rounded, bordered surface card matching the web app's `rounded-3xl`
/// cards. Used everywhere for consistent elevation/spacing.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.borderRadius = AppRadius.xl,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return Material(
      color: color ?? context.scheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: context.colors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}
