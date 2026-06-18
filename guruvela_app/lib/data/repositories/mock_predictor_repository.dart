import '../../core/constants/predictor_constants.dart';
import '../models/college_prediction.dart';
import '../models/csab_prediction.dart';
import '../models/predictor_query.dart';
import 'predictor_repository.dart';

/// Offline predictor that synthesizes plausible cutoff rows around the user's
/// rank. Lets the whole app run end-to-end without Supabase credentials.
///
/// The generated data deliberately spans high/medium/low probability buckets
/// so the result UI (badges, stats, filtering) is fully exercised.
class MockPredictorRepository implements PredictorRepository {
  const MockPredictorRepository();

  static const _institutes = [
    'Indian Institute of Technology Bombay',
    'Indian Institute of Technology Delhi',
    'Indian Institute of Technology Madras',
    'National Institute of Technology Tiruchirappalli',
    'National Institute of Technology Warangal',
    'National Institute of Technology Surathkal',
    'Indian Institute of Information Technology Allahabad',
    'Indian Institute of Information Technology Gwalior',
    'Sardar Vallabhbhai National Institute of Technology Surat',
    'Malaviya National Institute of Technology Jaipur',
    'Visvesvaraya National Institute of Technology Nagpur',
    'Motilal Nehru National Institute of Technology Allahabad',
  ];

  static const _branches = [
    'Computer Science and Engineering',
    'Electronics and Communication Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Information Technology',
    'Chemical Engineering',
    'Mathematics and Computing',
  ];

  @override
  Future<List<CollegePrediction>> fetchJosaa(PredictorQuery query) async {
    final userRank = query.rankInt;
    if (userRank == null || userRank <= 0) {
      throw const PredictorValidationException('Please enter a valid rank.');
    }
    await _simulateLatency();

    final rows = _generateRows(userRank).map((row) {
      return {
        ...row,
        'seat_type': query.category,
        'quota': query.effectiveQuota,
        'gender': query.gender,
        'is_preparatory': query.isPreparatoryRank,
        'exam_type': query.examType,
        'year': PredictorConstants.josaaPredictionYear,
        'round_no': PredictorConstants.josaaPredictionRound,
      };
    }).toList();

    return rows
        .where((r) =>
            !RegExp('architecture', caseSensitive: false)
                .hasMatch(r['branch_name'] as String))
        .map((r) => CollegePrediction.fromMap(r, userRank: userRank))
        .toList()
      ..sort((a, b) => a.closingRank.compareTo(b.closingRank));
  }

  @override
  Future<List<CsabPrediction>> fetchCsab(CsabQuery query) async {
    final userRank = query.rankInt;
    if (userRank == null || userRank <= 0) {
      throw const PredictorValidationException(
        'Invalid rank entered. Please enter a positive number.',
      );
    }
    await _simulateLatency();

    // CSAB only returns rows whose closing rank >= user rank.
    final rows = _generateRows(userRank)
        .where((r) => (r['closing_rank'] as int) >= userRank)
        .map((row) => {
              ...row,
              'seat_type': query.category,
              'quota': query.quota,
              'gender': query.gender,
              'year': PredictorConstants.csabPredictionYear,
              'round_no': PredictorConstants.csabPredictionRound,
            })
        .toList();

    return rows.map(CsabPrediction.fromMap).toList()
      ..sort((a, b) => a.closingRank.compareTo(b.closingRank));
  }

  /// Deterministically generates ~36 rows whose closing ranks fan out around
  /// [userRank] so high/medium/low buckets all appear.
  List<Map<String, dynamic>> _generateRows(int userRank) {
    final rows = <Map<String, dynamic>>[];
    var id = 1;
    // Offsets relative to user rank, expressed as fractions, to spread results.
    const spread = [
      -0.6, -0.3, -0.1, 0.0, 0.05, 0.15, 0.3, 0.5, 0.8, 1.2, 2.0, 3.5,
    ];
    for (var i = 0; i < _institutes.length; i++) {
      final institute = _institutes[i];
      final branch = _branches[i % _branches.length];
      final factor = spread[i % spread.length];
      final closing = (userRank + (userRank * factor)).round().clamp(1, 900000);
      final opening = (closing * 0.6).round().clamp(1, closing);
      rows.add({
        'id': 'mock-${id++}',
        'institute_name': institute,
        'branch_name': branch,
        'opening_rank': opening,
        'closing_rank': closing,
      });
      // Add a second branch per institute for a denser, more realistic list.
      final branch2 = _branches[(i + 3) % _branches.length];
      final closing2 = (closing * 1.25).round().clamp(1, 900000);
      rows.add({
        'id': 'mock-${id++}',
        'institute_name': institute,
        'branch_name': branch2,
        'opening_rank': (closing2 * 0.6).round(),
        'closing_rank': closing2,
      });
    }
    return rows;
  }

  Future<void> _simulateLatency() =>
      Future<void>.delayed(const Duration(milliseconds: 450));
}
