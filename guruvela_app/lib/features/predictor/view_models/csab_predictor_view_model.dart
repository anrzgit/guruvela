import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/predictor_constants.dart';
import '../../../data/models/csab_prediction.dart';
import '../../../data/models/predictor_query.dart';
import '../../../data/repositories/predictor_repository.dart';
import '../../../providers/core_providers.dart';

/// UI state for the CSAB Special Round predictor.
class CsabPredictorState extends Equatable {
  const CsabPredictorState({
    this.query = const CsabQuery(),
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.error,
    this.filterText = '',
    this.visibleCount = PredictorConstants.resultsPageSize,
  });

  final CsabQuery query;
  final List<CsabPrediction> results;
  final bool isLoading;
  final bool hasSearched;
  final String? error;
  final String filterText;
  final int visibleCount;

  List<CsabPrediction> get filtered {
    if (filterText.trim().isEmpty) return results;
    final q = filterText.toLowerCase();
    return results
        .where((r) =>
            r.instituteName.toLowerCase().contains(q) ||
            r.branchName.toLowerCase().contains(q))
        .toList();
  }

  List<CsabPrediction> get visible => filtered.take(visibleCount).toList();

  int get remaining =>
      (filtered.length - visibleCount).clamp(0, filtered.length);

  CsabPredictorState copyWith({
    CsabQuery? query,
    List<CsabPrediction>? results,
    bool? isLoading,
    bool? hasSearched,
    Object? error = _noChange,
    String? filterText,
    int? visibleCount,
  }) {
    return CsabPredictorState(
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

class CsabPredictorViewModel extends AutoDisposeNotifier<CsabPredictorState> {
  @override
  CsabPredictorState build() => const CsabPredictorState();

  PredictorRepository get _repo => ref.read(predictorRepositoryProvider);

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
      final results = await _repo.fetchCsab(state.query);
      state = state.copyWith(results: results, isLoading: false);
    } on PredictorValidationException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch CSAB predictions. Please try again later.',
        isLoading: false,
      );
    }
  }
}

final csabPredictorProvider =
    AutoDisposeNotifierProvider<CsabPredictorViewModel, CsabPredictorState>(
        CsabPredictorViewModel.new);
