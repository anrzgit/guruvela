import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/predictor_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../data/models/college_prediction.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/form_fields.dart';
import '../../shared/widgets/info_banner.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/probability_badge.dart';
import '../../shared/widgets/state_views.dart';
import '../view_models/josaa_predictor_view_model.dart';

/// JoSAA/CSAB Rank Predictor — port of `RankPredictorPage.jsx`.
class JosaaPredictorScreen extends ConsumerWidget {
  const JosaaPredictorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(josaaPredictorProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rank Predictor')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PageHero(
            title: 'JoSAA/CSAB Rank Predictor',
            subtitle:
                'Forecast your admission chances using historical counselling '
                'data with our advanced prediction engine.',
            icon: Icons.insights_outlined,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _JosaaForm(),
                const SizedBox(height: AppSpacing.lg),
                if (state.hasSearched && !state.isLoading && state.error == null)
                  _StatsRow(state: state),
                if (state.hasSearched && !state.isLoading && state.error == null)
                  const SizedBox(height: AppSpacing.lg),
                _ResultsSection(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JosaaForm extends ConsumerWidget {
  const _JosaaForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(josaaPredictorProvider.notifier);
    final query = ref.watch(josaaPredictorProvider).query;
    final isLoading = ref.watch(josaaPredictorProvider).isLoading;
    final isAdvanced = query.isAdvanced;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: context.scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Prediction Parameters', style: context.text.titleLarge),
            ],
          ),
          const Divider(height: AppSpacing.lg * 2),
          LabeledDropdown(
            label: 'Exam Type',
            value: query.examType,
            items: PredictorConstants.examTypes,
            onChanged: (v) => v != null ? vm.updateExamType(v) : null,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledTextField(
            label: isAdvanced ? 'JEE Advanced Rank' : 'JEE Main Rank (CRL)',
            hint: 'e.g., 15000',
            keyboardType: TextInputType.number,
            onChanged: vm.updateRank,
            onSubmitted: (_) => vm.search(),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledDropdown(
            label: 'Category',
            value: query.category,
            items: PredictorConstants.categories,
            onChanged: (v) => v != null ? vm.updateCategory(v) : null,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledDropdown(
            label: 'Gender',
            value: query.gender,
            items: PredictorConstants.genders,
            onChanged: (v) => v != null ? vm.updateGender(v) : null,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledDropdown(
            label: 'Home State / Quota',
            value: isAdvanced ? PredictorConstants.advancedQuota : query.quota,
            items: isAdvanced
                ? const [PredictorConstants.advancedQuota]
                : PredictorConstants.josaaQuotas,
            enabled: !isAdvanced,
            helper: isAdvanced ? 'JEE Advanced is All-India only.' : null,
            onChanged: (v) => v != null ? vm.updateQuota(v) : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: isLoading ? null : vm.search,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.track_changes, size: 20),
            label: Text(isLoading ? 'Processing...' : 'Generate Prediction'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});
  final JosaaPredictorState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'TOTAL OPTIONS',
            value: '${state.totalOptions}',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            label: 'HIGH PROBABILITY',
            value: '${state.highProbabilityCount}',
            highlight: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            label: 'TOP TIER',
            value: '${state.topTierCount}',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.text.labelSmall
                ?.copyWith(color: context.colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: context.text.displaySmall?.copyWith(
              color: highlight
                  ? context.scheme.primary
                  : context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSection extends ConsumerWidget {
  const _ResultsSection({required this.state});
  final JosaaPredictorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(josaaPredictorProvider.notifier);

    if (state.error != null) {
      return InfoBanner(message: state.error!, kind: BannerKind.error);
    }
    if (!state.hasSearched && !state.isLoading) {
      return const SizedBox(
        height: 320,
        child: EmptyStateView(
          icon: Icons.calculate_outlined,
          title: 'Ready for Prediction',
          subtitle:
              'Enter your parameters above to generate an accurate list of '
              'predicted institutes.',
        ),
      );
    }
    if (state.isLoading) {
      return const SizedBox(
        height: 320,
        child: LoadingView(message: 'Crunching data...'),
      );
    }
    if (state.results.isEmpty) {
      return const SizedBox(
        height: 320,
        child: EmptyStateView(
          icon: Icons.search_off,
          title: 'No colleges found',
          subtitle:
              'No colleges matched your criteria. Try adjusting your rank or '
              'quota.',
        ),
      );
    }

    final visible = state.visible;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Predicted Institutes',
                    style: context.text.titleLarge),
              ),
              IconButton(
                tooltip: 'Export CSV',
                onPressed: () => CsvExporter.exportJosaa(state.filtered),
                icon: const Icon(Icons.download_outlined),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            onChanged: vm.updateFilter,
            decoration: const InputDecoration(
              hintText: 'Filter institutes or branches...',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) => _ResultTile(item: visible[i]),
          ),
          if (state.remaining > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: vm.loadMore,
              icon: const Icon(Icons.expand_more),
              label: Text('Load More Results (${state.remaining} left)'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.item});
  final CollegePrediction item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.instituteName,
                  style: context.text.titleSmall
                      ?.copyWith(color: context.colors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  item.branchName,
                  style: context.text.bodySmall
                      ?.copyWith(color: context.colors.textMuted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    _MetaChip(item.quota),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'CR: ${item.closingRank}',
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ProbabilityBadge(item.level),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(text, style: context.text.bodySmall),
    );
  }
}
