import 'package:equatable/equatable.dart';

import '../../core/constants/predictor_constants.dart';

/// A single CSAB Special Round cutoff row (`csab_college_cutoffs` table).
///
/// Unlike JoSAA, CSAB probability is computed from the raw rank gap at display
/// time (see [levelFor]) rather than stored, matching the web app.
class CsabPrediction extends Equatable {
  const CsabPrediction({
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

  /// CSAB probability bucket:
  ///   diff = closing_rank - userRank
  ///   diff > 5000 -> High
  ///   diff > 0    -> Medium
  ///   else        -> Low
  ProbabilityLevel levelFor(int userRank) {
    final diff = closingRank - userRank;
    if (diff > 5000) return ProbabilityLevel.high;
    if (diff > 0) return ProbabilityLevel.medium;
    return ProbabilityLevel.low;
  }

  factory CsabPrediction.fromMap(Map<String, dynamic> map) {
    return CsabPrediction(
      id: '${map['id']}',
      instituteName: (map['institute_name'] ?? '') as String,
      branchName: (map['branch_name'] ?? '') as String,
      quota: (map['quota'] ?? '') as String,
      seatType: (map['seat_type'] ?? '') as String,
      gender: map['gender'] as String?,
      openingRank: (map['opening_rank'] as num?)?.toInt(),
      closingRank: (map['closing_rank'] as num).toInt(),
      year: (map['year'] as num?)?.toInt() ?? 0,
      roundNo: (map['round_no'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, instituteName, branchName, quota, closingRank];
}
