import 'package:flutter/material.dart';

import '../../../core/constants/predictor_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Pill badge showing High / Medium / Low admission probability, colored like
/// the web app's badges.
class ProbabilityBadge extends StatelessWidget {
  const ProbabilityBadge(this.level, {super.key});

  final ProbabilityLevel level;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final (label, bg, fg) = switch (level) {
      ProbabilityLevel.high => ('High', scheme.primary, Colors.white),
      ProbabilityLevel.medium => (
          'Medium',
          AppColors.probMedium,
          AppColors.probMediumText,
        ),
      ProbabilityLevel.low => (
          'Low',
          AppColors.probLow,
          AppColors.probLowText,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: bg),
      ),
      child: Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: fg,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
