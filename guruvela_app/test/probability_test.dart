import 'package:flutter_test/flutter_test.dart';
import 'package:guruvela_app/core/constants/predictor_constants.dart';
import 'package:guruvela_app/data/models/college_prediction.dart';
import 'package:guruvela_app/data/models/csab_prediction.dart';

/// Verifies the probability formulas match the web app
/// (`fetchCollegePredictions.js` and `CsabRankPredictorPage.jsx`).
void main() {
  CollegePrediction josaa(int closing, int userRank) =>
      CollegePrediction.fromMap({
        'id': 'x',
        'institute_name': 'Indian Institute of Technology Bombay',
        'branch_name': 'CSE',
        'quota': 'OS',
        'seat_type': 'OPEN',
        'gender': 'Gender-Neutral',
        'opening_rank': closing - 100,
        'closing_rank': closing,
        'year': 2024,
        'round_no': 6,
        'is_preparatory': false,
        'exam_type': 'JEE Main',
      }, userRank: userRank);

  group('JoSAA probability buckets', () {
    test('diff >= 200 -> 95 (High)', () {
      final p = josaa(1300, 1000); // diff = 300
      expect(p.probability, 95);
      expect(p.level, ProbabilityLevel.high);
    });

    test('-50 <= diff < 200 -> 75 (Medium)', () {
      final p = josaa(1100, 1000); // diff = 100
      expect(p.probability, 75);
      expect(p.level, ProbabilityLevel.medium);
    });

    test('boundary diff == 200 -> 95', () {
      expect(josaa(1200, 1000).probability, 95);
    });

    test('boundary diff == -50 -> 75', () {
      expect(josaa(950, 1000).probability, 75);
    });

    test('diff < -50 -> 30 (Low)', () {
      final p = josaa(900, 1000); // diff = -100
      expect(p.probability, 30);
      expect(p.level, ProbabilityLevel.low);
    });

    test('top-tier detection recognizes IITs and NITs', () {
      expect(josaa(1300, 1000).isTopTier, isTrue);
      final nit = CollegePrediction.fromMap({
        'id': 'y',
        'institute_name': 'National Institute of Technology Warangal',
        'branch_name': 'ECE',
        'quota': 'OS',
        'seat_type': 'OPEN',
        'closing_rank': 5000,
        'year': 2024,
        'round_no': 6,
        'is_preparatory': false,
        'exam_type': 'JEE Main',
      }, userRank: 4000);
      expect(nit.isTopTier, isTrue);
    });
  });

  group('CSAB probability buckets', () {
    CsabPrediction csab(int closing) => CsabPrediction.fromMap({
          'id': 'x',
          'institute_name': 'Test NIT',
          'branch_name': 'ECE',
          'quota': 'OS',
          'seat_type': 'OPEN',
          'gender': 'Gender-Neutral',
          'opening_rank': 100,
          'closing_rank': closing,
          'year': 2024,
          'round_no': 2,
        });

    test('diff > 5000 -> High', () {
      expect(csab(7000).levelFor(1000), ProbabilityLevel.high);
    });

    test('0 < diff <= 5000 -> Medium', () {
      expect(csab(2000).levelFor(1000), ProbabilityLevel.medium);
    });

    test('diff <= 0 -> Low', () {
      expect(csab(1000).levelFor(1000), ProbabilityLevel.low);
    });
  });
}
