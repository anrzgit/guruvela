import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// A labelled dropdown used throughout the predictor forms.
class LabeledDropdown extends StatelessWidget {
  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.helper,
    this.enabled = true,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? helper;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          items: [
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(item)),
          ],
          onChanged: enabled ? onChanged : null,
          style: context.text.bodyMedium
              ?.copyWith(color: context.colors.textPrimary),
        ),
        if (helper != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helper!,
            style: context.text.bodySmall
                ?.copyWith(color: context.colors.textMuted),
          ),
        ],
      ],
    );
  }
}

/// A labelled text/number field used in the predictor forms.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.keyboardType,
    this.controller,
    this.enabled = true,
    this.onSubmitted,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.text.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
