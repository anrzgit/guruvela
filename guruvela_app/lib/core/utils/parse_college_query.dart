import '../../data/models/parsed_college_query.dart';

/// Category keyword -> canonical seat type. Order matters: PwD variants are
/// listed first so they match before the shorter non-PwD keywords (e.g.
/// `sc pwd` must beat `sc`). Ported verbatim from `parseCollegeQuery.js`.
const Map<String, String> categoryMap = {
  // PwD variations first
  'gen pwd': 'OPEN (PwD)',
  'gen-pwd': 'OPEN (PwD)',
  'general pwd': 'OPEN (PwD)',
  'general-pwd': 'OPEN (PwD)',
  'open pwd': 'OPEN (PwD)',
  'open-pwd': 'OPEN (PwD)',
  'ews pwd': 'EWS (PwD)',
  'ews-pwd': 'EWS (PwD)',
  'obc ncl pwd': 'OBC-NCL (PwD)',
  'obc-ncl pwd': 'OBC-NCL (PwD)',
  'obc-ncl-pwd': 'OBC-NCL (PwD)',
  'sc pwd': 'SC (PwD)',
  'sc-pwd': 'SC (PwD)',
  'st pwd': 'ST (PwD)',
  'st-pwd': 'ST (PwD)',
  // Standard non-PwD keywords
  'obc ncl': 'OBC-NCL',
  'obc-ncl': 'OBC-NCL',
  'obc': 'OBC-NCL',
  'sc': 'SC',
  'st': 'ST',
  'ews': 'EWS',
  'gen': 'OPEN',
  'general': 'OPEN',
  'open': 'OPEN',
};

const Map<String, String> stateKeywords = {
  'andhra pradesh': 'Andhra Pradesh',
  'arunachal pradesh': 'Arunachal Pradesh',
  'assam': 'Assam',
  'bihar': 'Bihar',
  'chhattisgarh': 'Chhattisgarh',
  'goa': 'Goa',
  'gujarat': 'Gujarat',
  'haryana': 'Haryana',
  'himachal pradesh': 'Himachal Pradesh',
  'jammu': 'Jammu and Kashmir',
  'kashmir': 'Jammu and Kashmir',
  'jharkhand': 'Jharkhand',
  'karnataka': 'Karnataka',
  'kerala': 'Kerala',
  'madhya pradesh': 'Madhya Pradesh',
  'maharashtra': 'Maharashtra',
  'manipur': 'Manipur',
  'meghalaya': 'Meghalaya',
  'mizoram': 'Mizoram',
  'nagaland': 'Nagaland',
  'odisha': 'Odisha',
  'orissa': 'Odisha',
  'punjab': 'Punjab',
  'rajasthan': 'Rajasthan',
  'sikkim': 'Sikkim',
  'tamil nadu': 'Tamil Nadu',
  'telangana': 'Telangana',
  'tripura': 'Tripura',
  'uttar pradesh': 'Uttar Pradesh',
  'uttarakhand': 'Uttarakhand',
  'west bengal': 'West Bengal',
  'delhi': 'Delhi',
  'ladakh': 'Ladakh',
  'chandigarh': 'Chandigarh',
  'andaman and nicobar': 'Andaman and Nicobar Islands',
  'dadra and nagar haveli': 'Dadra and Nagar Haveli and Daman and Diu',
  'daman and diu': 'Dadra and Nagar Haveli and Daman and Diu',
  'puducherry': 'Puducherry',
  'lakshadweep': 'Lakshadweep',
};

const Map<String, String> cityKeywords = {
  'warangal': 'Telangana',
  'trichy': 'Tamil Nadu',
  'kurukshetra': 'Haryana',
  'jaipur': 'Rajasthan',
  'surat': 'Gujarat',
  'gandhinagar': 'Gujarat',
};

final RegExp _rankIsRe = RegExp(r'\brank(?:\s*is)?\s*#?(\d{1,4})\b');
final RegExp _rankSuffixRe = RegExp(r'#?(\d{1,4})\s*rank\b');
final RegExp _rankFallbackRe = RegExp(r'\b(\d{3,})\b');
final RegExp _branchRe = RegExp(
  r'\b(CSE|Computer Science|ECE|Electrical|Electronics|Mechanical|Civil|IT|Information Technology)\b',
  caseSensitive: false,
);
final RegExp _instituteRe = RegExp(
  r'(?:at|in|for)\s+([A-Za-z ]*(?:IIT|NIT|IIIT)[A-Za-z ]*)',
  caseSensitive: false,
);

// Pre-compile category keyword matchers, escaping regex metacharacters in keys.
final List<MapEntry<RegExp, String>> _categoryRegexMap =
    categoryMap.entries.map((e) {
  final escaped = e.key.replaceAllMapped(
    RegExp(r'[-\\*+?.()|[\]{}]'),
    (m) => '\\${m[0]}',
  );
  return MapEntry(RegExp('\\b$escaped\\b', caseSensitive: false), e.value);
}).toList();

bool _wordHit(String key, String haystack) =>
    RegExp('\\b${RegExp.escape(key)}\\b', caseSensitive: false)
        .hasMatch(haystack);

/// Extracts rank, category, branch, institute, state and exam type from a
/// free-text query. Direct Dart port of `parseCollegeQuery.js`.
ParsedCollegeQuery parseCollegeQuery(String text) {
  final lower = text.toLowerCase();

  // Rank: "rank is 42" / "42 rank" first, then any 3+ digit number.
  RegExpMatch? rankMatch = _rankIsRe.firstMatch(lower);
  String? rankStr = rankMatch?.group(1);
  if (rankStr == null) {
    rankMatch = _rankSuffixRe.firstMatch(lower);
    rankStr = rankMatch?.group(1);
  }
  if (rankStr == null) {
    rankMatch = _rankFallbackRe.firstMatch(lower);
    rankStr = rankMatch?.group(1);
  }
  final rank = rankStr != null ? int.tryParse(rankStr) : null;

  // Category (first matching keyword, PwD-priority order preserved).
  String? category;
  for (final entry in _categoryRegexMap) {
    if (entry.key.hasMatch(lower)) {
      category = entry.value;
      break;
    }
  }

  final branchMatch = _branchRe.firstMatch(text);
  final branch = branchMatch?.group(0);

  final instituteMatch = _instituteRe.firstMatch(text);
  final institute = instituteMatch?.group(1)?.trim();

  // State by name, then by city alias.
  String? state;
  for (final entry in stateKeywords.entries) {
    if (_wordHit(entry.key, lower)) {
      state = entry.value;
      break;
    }
  }
  if (state == null) {
    for (final entry in cityKeywords.entries) {
      if (_wordHit(entry.key, lower)) {
        state = entry.value;
        break;
      }
    }
  }

  // Exam type — Advanced variants checked before Main.
  String? examType;
  if (RegExp(r'\bjee\s*advanced\b').hasMatch(lower) ||
      RegExp(r'\bjee\s*advance\b').hasMatch(lower) ||
      RegExp(r'\bjee[-\s]?adv\b').hasMatch(lower) ||
      RegExp(r'\bjeeadv(?:ance|anced)?\b').hasMatch(lower)) {
    examType = 'JEE Advanced';
  } else if (RegExp(r'\bjee\s*mains?\b').hasMatch(lower) ||
      RegExp(r'\bjee[-\s]?main\b').hasMatch(lower)) {
    examType = 'JEE Main';
  }

  final isCollegeQuery = rank != null || branch != null || institute != null;

  return ParsedCollegeQuery(
    rank: rank,
    category: category,
    branch: branch,
    institute: institute,
    state: state,
    examType: examType,
    isCollegeQuery: isCollegeQuery,
  );
}
