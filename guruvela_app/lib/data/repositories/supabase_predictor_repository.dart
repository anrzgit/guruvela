import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/predictor_constants.dart';
import '../models/college_prediction.dart';
import '../models/csab_prediction.dart';
import '../models/predictor_query.dart';
import 'predictor_repository.dart';

/// Real Supabase-backed predictor. Query shape ported 1:1 from
/// `fetchCollegePredictions.js` and `CsabRankPredictorPage.jsx`.
class SupabasePredictorRepository implements PredictorRepository {
  SupabasePredictorRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<CollegePrediction>> fetchJosaa(PredictorQuery query) async {
    final userRank = query.rankInt;
    if (userRank == null || userRank <= 0) {
      throw const PredictorValidationException('Please enter a valid rank.');
    }

    // .eq() filters mirror the web query exactly.
    var builder = _client
        .from(SupabaseTables.collegeCutoffs)
        .select(
          'institute_name, branch_name, quota, seat_type, gender, '
          'opening_rank, closing_rank, year, round_no, is_preparatory, '
          'id, exam_type',
        )
        .eq('year', PredictorConstants.josaaPredictionYear)
        .eq('round_no', PredictorConstants.josaaPredictionRound)
        .eq('exam_type', query.examType)
        .eq('seat_type', query.category);

    final state = query.state;
    if (state != null && query.quota == 'HS') {
      builder = builder.eq('state', state).eq('quota', 'HS');
    } else if (state != null && query.quota == 'OS') {
      builder = builder.neq('state', state).eq('quota', 'OS');
    } else if (query.effectiveQuota.isNotEmpty) {
      builder = builder.eq('quota', query.effectiveQuota);
    }

    if (query.gender.isNotEmpty) {
      builder = builder.eq('gender', query.gender);
    }
    builder = builder.eq('is_preparatory', query.isPreparatoryRank);

    final minClosingRank =
        (userRank - PredictorConstants.reachRankBuffer).clamp(1, userRank);
    builder = builder.gte('closing_rank', minClosingRank);

    final data = await builder
        .order('closing_rank', ascending: true)
        .limit(100);

    return _mapJosaa(data, userRank);
  }

  List<CollegePrediction> _mapJosaa(List<dynamic> rows, int userRank) {
    final archRe = RegExp('architecture', caseSensitive: false);
    return rows
        .cast<Map<String, dynamic>>()
        .where((r) => !archRe.hasMatch((r['branch_name'] ?? '') as String))
        .map((r) => CollegePrediction.fromMap(r, userRank: userRank))
        .toList();
  }

  @override
  Future<List<CsabPrediction>> fetchCsab(CsabQuery query) async {
    final userRank = query.rankInt;
    if (userRank == null || userRank <= 0) {
      throw const PredictorValidationException(
        'Invalid rank entered. Please enter a positive number.',
      );
    }

    var builder = _client
        .from(SupabaseTables.csabCollegeCutoffs)
        .select(
          'institute_name, branch_name, quota, seat_type, gender, '
          'opening_rank, closing_rank, year, round_no, id',
        )
        .eq('year', PredictorConstants.csabPredictionYear)
        .eq('round_no', PredictorConstants.csabPredictionRound)
        .eq('seat_type', query.category);

    if (query.quota.isNotEmpty) {
      builder = builder.eq('quota', query.quota);
    }
    if (query.gender.isNotEmpty) {
      builder = builder.eq('gender', query.gender);
    }
    builder = builder.gte('closing_rank', userRank);

    final data = await builder
        .order('closing_rank', ascending: true)
        .limit(100);

    return data
        .cast<Map<String, dynamic>>()
        .map(CsabPrediction.fromMap)
        .toList();
  }
}
