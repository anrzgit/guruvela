import 'package:equatable/equatable.dart';

/// Result of [parseCollegeQuery] — the structured fields pulled out of a
/// free-text chatbot message. Mirrors the object returned by the web app's
/// `parseCollegeQuery.js`.
class ParsedCollegeQuery extends Equatable {
  const ParsedCollegeQuery({
    this.rank,
    this.category,
    this.branch,
    this.institute,
    this.state,
    this.examType,
    required this.isCollegeQuery,
  });

  final int? rank;
  final String? category;
  final String? branch;
  final String? institute;
  final String? state;
  final String? examType;
  final bool isCollegeQuery;

  @override
  List<Object?> get props =>
      [rank, category, branch, institute, state, examType, isCollegeQuery];
}
