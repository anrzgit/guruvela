import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/predictor_constants.dart';
import '../../../data/models/college_prediction.dart';
import '../../../data/models/predictor_query.dart';
import '../../../data/repositories/predictor_repository.dart';
import '../../../providers/core_providers.dart';

/// UI state for the JoSAA predictor: the form [query], async [results], the
/// search/loading/error flags, plus the client-side filter and pagination.
class JosaaPredictorState extends Equatable {
  const JosaaPredictorState({
    this.query = const PredictorQuery(),
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.error,
    this.filterText = '',
    this.visibleCount = PredictorConstants.resultsPageSize,
  });

  final PredictorQuery query;
  final List<CollegePrediction> results;
  final bool isLoading;
  final bool hasSearched;
  final String? error;
  final String filterText;
  final int visibleCount;

  List<CollegePrediction> get filtered {
    if (filterText.trim().isEmpty) return results;
    final q = filterText.toLowerCase();
    return results
        .where((r) =>
            r.instituteName.toLowerCase().contains(q) ||
            r.branchName.toLowerCase().contains(q))
        .toList();
  }

  List<CollegePrediction> get visible =>
      filtered.take(visibleCount).toList();

  int get remaining =>
      (filtered.length - visibleCount).clamp(0, filtered.length);

  // Stat-card values.
  int get totalOptions => results.length;
  int get highProbabilityCount =>
      results.where((r) => r.probability > 80).length;
  int get topTierCount => results.where((r) => r.isTopTier).length;

  JosaaPredictorState copyWith({
    PredictorQuery? query,
    List<CollegePrediction>? results,
    bool? isLoading,
    bool? hasSearched,
    Object? error = _noChange,
    String? filterText,
    int? visibleCount,
  }) {
    return JosaaPredictorState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      error: error == _noChange ? this.error : error as String?,
      filterText: filterText ?? this.filterText,
      visibleCount: visibleCount ?? this.visibleCount,
    );
  }

  static const _noChange = Object();

  @override
  List<Object?> get props =>
      [query, results, isLoading, hasSearched, error, filterText, visibleCount];
}

class JosaaPredictorViewModel extends AutoDisposeNotifier<JosaaPredictorState> {
  @override
  JosaaPredictorState build() => const JosaaPredictorState();

  PredictorRepository get _repo => ref.read(predictorRepositoryProvider);

  void updateExamType(String value) {
    // Switching to Advanced forces the All-India quota.
    state = state.copyWith(
      query: state.query.copyWith(examType: value),
    );
  }

  void updateRank(String value) =>
      state = state.copyWith(query: state.query.copyWith(rank: value));

  void updateCategory(String value) =>
      state = state.copyWith(query: state.query.copyWith(category: value));

  void updateGender(String value) =>
      state = state.copyWith(query: state.query.copyWith(gender: value));

  void updateQuota(String value) =>
      state = state.copyWith(query: state.query.copyWith(quota: value));

  void updateFilter(String value) =>
      state = state.copyWith(filterText: value);

  void loadMore() => state = state.copyWith(
        visibleCount: state.visibleCount + PredictorConstants.resultsPageSize,
      );

  Future<void> search() async {
    final rank = state.query.rankInt;
    if (rank == null || rank <= 0) {
      state = state.copyWith(
        error: 'Please enter your rank.',
        results: const [],
        hasSearched: true,
        isLoading: false,
      );
      return;
    }
    state = state.copyWith(
      isLoading: true,
      hasSearched: true,
      error: null,
      results: const [],
      visibleCount: PredictorConstants.resultsPageSize,
    );
    try {
      final results = await _repo.fetchJosaa(state.query);
      state = state.copyWith(results: results, isLoading: false);
    } on PredictorValidationException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch predictions. Please try again later.',
        isLoading: false,
      );
    }
  }
}

final josaaPredictorProvider = AutoDisposeNotifierProvider<
    JosaaPredictorViewModel, JosaaPredictorState>(JosaaPredictorViewModel.new);
