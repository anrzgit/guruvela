import 'package:equatable/equatable.dart';

import '../../core/constants/predictor_constants.dart';

/// A single JoSAA college-cutoff row with a computed [probability].
///
/// Maps the `college_cutoffs` table. The probability is derived the same way
/// as the web app (`fetchCollegePredictions.js`).
class CollegePrediction extends Equatable {
  const CollegePrediction({
    required this.id,
    required this.instituteName,
    required this.branchName,
    required this.quota,
    required this.seatType,
    required this.gender,
    required this.openingRank,
    required this.closingRank,
    required this.year,
    required this.roundNo,
    required this.isPreparatory,
    required this.examType,
    required this.probability,
  });

  final String id;
  final String instituteName;
  final String branchName;
  final String quota;
  final String seatType;
  final String? gender;
  final int? openingRank;
  final int closingRank;
  final int year;
  final int roundNo;
  final bool isPreparatory;
  final String examType;

  /// 0-100 admission likelihood.
  final int probability;

  ProbabilityLevel get level {
    if (probability > 90) return ProbabilityLevel.high;
    if (probability >= 50) return ProbabilityLevel.medium;
    return ProbabilityLevel.low;
  }

  /// True for IITs and NITs (used for the "Top Tier" stat).
  bool get isTopTier {
    final upper = instituteName.toUpperCase();
    return upper.contains('INDIAN INSTITUTE OF TECHNOLOGY') ||
        upper.contains('NATIONAL INSTITUTE OF TECHNOLOGY') ||
        upper.startsWith('IIT') ||
        upper.startsWith('NIT');
  }

  /// Builds from a Supabase row, computing probability against [userRank]
  /// exactly as the web app does:
  ///   diff = closing_rank - userRank
  ///   diff >= 200            -> 95
  ///   -50 <= diff < 200      -> 75
  ///   else                   -> 30
  factory CollegePrediction.fromMap(
    Map<String, dynamic> map, {
    required int userRank,
  }) {
    final closing = (map['closing_rank'] as num).toInt();
    final diff = closing - userRank;
    final int prob;
    if (diff >= 200) {
      prob = 95;
    } else if (diff >= -50 && diff < 200) {
      prob = 75;
    } else {
      prob = 30;
    }

    return CollegePrediction(
      id: '${map['id']}',
      instituteName: (map['institute_name'] ?? '') as String,
      branchName: (map['branch_name'] ?? '') as String,
      quota: (map['quota'] ?? '') as String,
      seatType: (map['seat_type'] ?? '') as String,
      gender: map['gender'] as String?,
      openingRank: (map['opening_rank'] as num?)?.toInt(),
      closingRank: closing,
      year: (map['year'] as num?)?.toInt() ?? 0,
      roundNo: (map['round_no'] as num?)?.toInt() ?? 0,
      isPreparatory: (map['is_preparatory'] as bool?) ?? false,
      examType: (map['exam_type'] ?? '') as String,
      probability: prob,
    );
  }

  @override
  List<Object?> get props => [id, instituteName, branchName, quota, closingRank];
}
