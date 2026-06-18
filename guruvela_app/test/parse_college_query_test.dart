import 'package:flutter_test/flutter_test.dart';
import 'package:guruvela_app/core/utils/parse_college_query.dart';

/// Mirrors `web/tests/parseCollegeQuery.test.js` to guarantee the Dart port
/// behaves identically to the original JS implementation.
void main() {
  group('parseCollegeQuery — rank extraction', () {
    test('"My rank is 42 and I want CSE" -> 42', () {
      expect(parseCollegeQuery('My rank is 42 and I want CSE').rank, 42);
    });

    test('"rank 5, category gen" -> 5', () {
      expect(parseCollegeQuery('rank 5, category gen').rank, 5);
    });

    test('"I have a 4231 rank in jee main" -> 4231 + JEE Main', () {
      final r = parseCollegeQuery('I have a 4231 rank in jee main');
      expect(r.rank, 4231);
      expect(r.examType, 'JEE Main');
    });

    test('"I want 3 colleges" -> no rank', () {
      expect(parseCollegeQuery('I want 3 colleges').rank, isNull);
    });
  });

  group('parseCollegeQuery — category (PwD priority)', () {
    test('"rank 123 obc-ncl pwd" -> OBC-NCL (PwD)', () {
      expect(
        parseCollegeQuery('rank 123 obc-ncl pwd').category,
        'OBC-NCL (PwD)',
      );
    });

    test('"rank 99 gen pwd" -> OPEN (PwD)', () {
      expect(parseCollegeQuery('rank 99 gen pwd').category, 'OPEN (PwD)');
    });

    test('"rank 100 ews-pwd" -> EWS (PwD)', () {
      expect(parseCollegeQuery('rank 100 ews-pwd').category, 'EWS (PwD)');
    });

    test('"I love science" -> no category (no false SC match)', () {
      expect(parseCollegeQuery('I love science').category, isNull);
    });

    test('"scam details" -> no category', () {
      expect(parseCollegeQuery('scam details').category, isNull);
    });
  });

  group('parseCollegeQuery — exam type', () {
    test('"rank 50 in jee advanced" -> JEE Advanced', () {
      expect(
        parseCollegeQuery('rank 50 in jee advanced').examType,
        'JEE Advanced',
      );
    });

    test('"rank 99 in JeeAdvance" -> JEE Advanced', () {
      expect(
        parseCollegeQuery('rank 99 in JeeAdvance').examType,
        'JEE Advanced',
      );
    });

    test('"rank 500 in jee advance" -> JEE Advanced', () {
      expect(
        parseCollegeQuery('rank 500 in jee advance').examType,
        'JEE Advanced',
      );
    });
  });

  group('parseCollegeQuery — state & city', () {
    test('"I\'m from Maharashtra with rank 1500" -> Maharashtra', () {
      expect(
        parseCollegeQuery("I'm from Maharashtra with rank 1500").state,
        'Maharashtra',
      );
    });

    test('"my state is karnataka" -> Karnataka', () {
      expect(parseCollegeQuery('my state is karnataka').state, 'Karnataka');
    });

    test('city: warangal -> Telangana', () {
      expect(parseCollegeQuery('colleges near warangal').state, 'Telangana');
    });

    test('city: trichy -> Tamil Nadu', () {
      expect(parseCollegeQuery('colleges in trichy').state, 'Tamil Nadu');
    });

    test('city: kurukshetra -> Haryana', () {
      expect(parseCollegeQuery('engineering in kurukshetra').state, 'Haryana');
    });

    test('city: jaipur -> Rajasthan', () {
      expect(parseCollegeQuery('admission at jaipur').state, 'Rajasthan');
    });

    test('city: surat -> Gujarat', () {
      expect(parseCollegeQuery('iit surat campus').state, 'Gujarat');
    });

    test('city: gandhinagar -> Gujarat', () {
      expect(
        parseCollegeQuery('rank 1000 gandhinagar institutes').state,
        'Gujarat',
      );
    });
  });
}
