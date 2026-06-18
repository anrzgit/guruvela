/// Prediction year/round values + dropdown option lists.
///
/// Ported verbatim from the web app's `src/config/constants.js` and the
/// option arrays hard-coded inside the predictor pages. Update the year/round
/// values here whenever the cutoff database changes.
abstract final class PredictorConstants {
  PredictorConstants._();

  static const int josaaPredictionYear = 2024;
  static const int josaaPredictionRound = 6;
  static const int csabPredictionYear = 2024;
  static const int csabPredictionRound = 2;

  static const int geminiMaxOutputTokens = 200;

  /// How many result rows to reveal per "Load More" tap (web used 15).
  static const int resultsPageSize = 15;

  /// Buffer applied below the user's rank so "reach" colleges show up.
  static const int reachRankBuffer = 500;

  static const List<String> examTypes = ['JEE Main', 'JEE Advanced'];

  static const List<String> categories = [
    'OPEN',
    'OPEN (PwD)',
    'EWS',
    'EWS (PwD)',
    'OBC-NCL',
    'OBC-NCL (PwD)',
    'SC',
    'SC (PwD)',
    'ST',
    'ST (PwD)',
  ];

  static const List<String> genders = [
    'Gender-Neutral',
    'Female-only (including Supernumerary)',
  ];

  /// Quota options for JEE Main (and CSAB).
  static const List<String> josaaQuotas = ['OS', 'HS', 'GO'];

  /// JEE Advanced is All-India only.
  static const String advancedQuota = 'AI';
}

/// Probability bucket used for badge labels/colors.
enum ProbabilityLevel { high, medium, low }
