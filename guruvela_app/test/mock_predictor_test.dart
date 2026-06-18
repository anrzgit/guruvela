import 'package:flutter_test/flutter_test.dart';
import 'package:guruvela_app/data/models/predictor_query.dart';
import 'package:guruvela_app/data/repositories/mock_predictor_repository.dart';
import 'package:guruvela_app/data/repositories/predictor_repository.dart';

void main() {
  const repo = MockPredictorRepository();

  group('MockPredictorRepository — JoSAA', () {
    test('rejects an invalid rank', () {
      expect(
        () => repo.fetchJosaa(const PredictorQuery(rank: '0')),
        throwsA(isA<PredictorValidationException>()),
      );
    });

    test('returns results sorted ascending by closing rank with no '
        'architecture branches', () async {
      final results =
          await repo.fetchJosaa(const PredictorQuery(rank: '5000'));
      expect(results, isNotEmpty);
      for (var i = 1; i < results.length; i++) {
        expect(
          results[i].closingRank >= results[i - 1].closingRank,
          isTrue,
        );
      }
      expect(
        results.any((r) => r.branchName.toLowerCase().contains('architecture')),
        isFalse,
      );
    });

    test('produces a spread of probability levels', () async {
      final results =
          await repo.fetchJosaa(const PredictorQuery(rank: '5000'));
      final probs = results.map((r) => r.probability).toSet();
      // Expect more than a single bucket given the synthetic spread.
      expect(probs.length, greaterThan(1));
    });
  });

  group('MockPredictorRepository — CSAB', () {
    test('only returns rows with closing rank >= user rank', () async {
      const userRank = 5000;
      final results = await repo.fetchCsab(const CsabQuery(rank: '$userRank'));
      expect(results, isNotEmpty);
      expect(results.every((r) => r.closingRank >= userRank), isTrue);
    });
  });
}
