import '../models/college_prediction.dart';
import '../models/csab_prediction.dart';
import '../models/predictor_query.dart';

/// Contract for fetching JoSAA and CSAB college predictions. Implemented by
/// [SupabasePredictorRepository] (real backend) and [MockPredictorRepository]
/// (offline sample data).
abstract interface class PredictorRepository {
  /// JoSAA prediction — mirrors `fetchCollegePredictions.js`.
  Future<List<CollegePrediction>> fetchJosaa(PredictorQuery query);

  /// CSAB Special Round prediction — mirrors `CsabRankPredictorPage`'s query.
  Future<List<CsabPrediction>> fetchCsab(CsabQuery query);
}

/// Thrown when a query is invalid (e.g. non-positive rank) so the UI can show
/// a friendly message instead of a generic failure.
class PredictorValidationException implements Exception {
  const PredictorValidationException(this.message);
  final String message;
  @override
  String toString() => message;
}
