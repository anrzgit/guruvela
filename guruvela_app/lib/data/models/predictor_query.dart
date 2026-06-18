import 'package:equatable/equatable.dart';

import '../../core/constants/predictor_constants.dart';

/// Immutable form state / query parameters for a JoSAA prediction request.
class PredictorQuery extends Equatable {
  const PredictorQuery({
    this.examType = 'JEE Main',
    this.rank = '',
    this.category = 'OPEN',
    this.gender = 'Gender-Neutral',
    this.quota = 'HS',
    this.state,
    this.isPreparatoryRank = false,
  });

  final String examType;
  final String rank;
  final String category;
  final String gender;
  final String quota;
  final String? state;
  final bool isPreparatoryRank;

  bool get isAdvanced => examType == 'JEE Advanced';

  /// Quota sent to the backend — JEE Advanced is always All-India.
  String get effectiveQuota =>
      isAdvanced ? PredictorConstants.advancedQuota : quota;

  int? get rankInt => int.tryParse(rank.trim());

  PredictorQuery copyWith({
    String? examType,
    String? rank,
    String? category,
    String? gender,
    String? quota,
    String? state,
    bool? isPreparatoryRank,
  }) {
    return PredictorQuery(
      examType: examType ?? this.examType,
      rank: rank ?? this.rank,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      quota: quota ?? this.quota,
      state: state ?? this.state,
      isPreparatoryRank: isPreparatoryRank ?? this.isPreparatoryRank,
    );
  }

  @override
  List<Object?> get props =>
      [examType, rank, category, gender, quota, state, isPreparatoryRank];
}

/// Immutable form state for a CSAB prediction request (no exam type / state).
class CsabQuery extends Equatable {
  const CsabQuery({
    this.rank = '',
    this.category = 'OPEN',
    this.gender = 'Gender-Neutral',
    this.quota = 'OS',
  });

  final String rank;
  final String category;
  final String gender;
  final String quota;

  int? get rankInt => int.tryParse(rank.trim());

  CsabQuery copyWith({
    String? rank,
    String? category,
    String? gender,
    String? quota,
  }) {
    return CsabQuery(
      rank: rank ?? this.rank,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      quota: quota ?? this.quota,
    );
  }

  @override
  List<Object?> get props => [rank, category, gender, quota];
}
