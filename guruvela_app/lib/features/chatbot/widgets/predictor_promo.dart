import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/language_provider.dart';

/// Dismissible banner promoting the JoSAA predictor, shown at the top of the
/// chat. Mirrors the web `predictorPopup`.
class PredictorPromo extends ConsumerWidget {
  const PredictorPromo({super.key, required this.onOpen, required this.onClose});

  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final lang = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.scheme.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curious about your college options? Try our JoSAA College '
                  'Predictor!',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: onOpen,
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      textStyle: context.text.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    child: const Text('JoSAA College Predictor'),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close),
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}
