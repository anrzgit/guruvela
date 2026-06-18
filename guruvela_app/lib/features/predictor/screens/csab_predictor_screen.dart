import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/predictor_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../data/models/csab_prediction.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/form_fields.dart';
import '../../shared/widgets/info_banner.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/probability_badge.dart';
import '../../shared/widgets/state_views.dart';
import '../view_models/csab_predictor_view_model.dart';

/// CSAB Special Round predictor — port of `CsabRankPredictorPage.jsx`.
class CsabPredictorScreen extends ConsumerWidget {
  const CsabPredictorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(csabPredictorProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('CSAB Predictor')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          PageHero(
            title: 'CSAB Rank Predictor',
            subtitle:
                'Forecast your admission chances in CSAB Special Round '
                '${PredictorConstants.csabPredictionRound} '
                '(${PredictorConstants.csabPredictionYear}).',
            icon: Icons.tune,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _CsabForm(),
                const SizedBox(height: AppSpacing.lg),
                _CsabResults(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CsabForm extends ConsumerWidget {
  const _CsabForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(csabPredictorProvider.notifier);
    final query = ref.watch(csabPredictorProvider).query;
    final isLoading = ref.watch(csabPredictorProvider).isLoading;

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
          LabeledTextField(
            label: 'Exam Type',
            controller: TextEditingController(text: 'JEE Main'),
            enabled: false,
            onChanged: (_) {},
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'CSAB operates only on JEE Main ranking.',
              style: context.text.bodySmall
                  ?.copyWith(color: context.colors.textMuted),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledTextField(
            label: 'JEE Main Rank (CRL)',
            hint: 'e.g., 15000',
            keyboardType: TextInputType.number,
            onChanged: vm.updateRank,
            onSubmitted: (_) => vm.search(),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledDropdown(
            label: 'Category (Seat Type)',
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
            label: 'Quota',
            value: query.quota,
            items: PredictorConstants.josaaQuotas,
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
            label: Text(isLoading ? 'Processing...' : 'Find Colleges (CSAB)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _CsabResults extends ConsumerWidget {
  const _CsabResults({required this.state});
  final CsabPredictorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(csabPredictorProvider.notifier);

    if (state.error != null) {
      return InfoBanner(message: state.error!, kind: BannerKind.error);
    }
    if (!state.hasSearched && !state.isLoading) {
      return const SizedBox(
        height: 320,
        child: EmptyStateView(
          icon: Icons.tune,
          title: 'Ready to predict your future?',
          subtitle:
              'Enter your rank and filters above to see which institutes and '
              'branches you are likely to get in the CSAB Special Round.',
        ),
      );
    }
    if (state.isLoading) {
      return const SizedBox(
        height: 320,
        child: LoadingView(message: 'Crunching historical CSAB data...'),
      );
    }
    if (state.results.isEmpty) {
      return SizedBox(
        height: 320,
        child: EmptyStateView(
          icon: Icons.warning_amber_rounded,
          iconColor: context.colors.warning,
          iconBackground: context.colors.warning.withValues(alpha: 0.12),
          title: 'No Match Found',
          subtitle:
              "We couldn't find institutes matching your criteria. Your rank "
              'might be higher than the cutoffs for these filters.',
        ),
      );
    }

    final rank = state.query.rankInt ?? 0;
    final visible = state.visible;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Predicted Institutes (CSAB)',
                        style: context.text.titleLarge),
                    Text(
                      'Found ${state.results.length} prospective branches '
                      'based on CSAB ${PredictorConstants.csabPredictionYear}',
                      style: context.text.bodySmall
                          ?.copyWith(color: context.colors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Export CSV',
                onPressed: () => CsvExporter.exportCsab(state.filtered),
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
            itemBuilder: (context, i) =>
                _CsabTile(item: visible[i], userRank: rank),
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

class _CsabTile extends StatelessWidget {
  const _CsabTile({required this.item, required this.userRank});
  final CsabPrediction item;
  final int userRank;

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
                Text(item.instituteName, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  item.branchName,
                  style: context.text.bodySmall
                      ?.copyWith(color: context.colors.textMuted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${item.quota} / ${item.seatType}',
                  style: context.text.bodySmall,
                ),
                Text(
                  'Closing: ${item.closingRank}'
                  '${item.openingRank != null ? '  •  Opening: ${item.openingRank}' : ''}',
                  style: context.text.bodySmall
                      ?.copyWith(color: context.colors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ProbabilityBadge(item.levelFor(userRank)),
        ],
      ),
    );
  }
}
