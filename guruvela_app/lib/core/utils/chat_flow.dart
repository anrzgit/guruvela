import '../utils/parse_college_query.dart';

/// The decision the chatbot reaches for a given message — drives which
/// backend (predictions / Gemini / fixed responses) the view model calls.
enum ChatFlowType {
  /// All params present → fetch & show college predictions.
  prediction,

  /// A college query but missing rank/category → ask for clarification.
  clarification,

  /// Tapped topic chip → look up a fixed response in Supabase.
  fixedResponse,

  /// General free-text question with Gemini configured → call Gemini.
  gemini,

  /// General question without Gemini → keyword fallback (findBestResponse).
  fallback,
}

/// The resolved prediction parameters when [ChatFlowType.prediction] fires.
class ChatPredictionParams {
  const ChatPredictionParams({
    required this.rank,
    required this.category,
    required this.examType,
    required this.quota,
    required this.state,
  });

  final int rank;
  final String category;
  final String examType;
  final String quota;
  final String state;
}

/// Outcome of [ChatFlow.handle].
class ChatFlowResult {
  const ChatFlowResult(this.type, {this.params});

  final ChatFlowType type;
  final ChatPredictionParams? params;
}

/// Pure, UI-independent chatbot state machine. Accumulates rank/category/
/// state/examType across turns and decides what to do next.
///
/// This is a faithful port of the routing logic in `ChatInterface.jsx`
/// (and the behaviors asserted by `chatbotReset.test.js` /
/// `chatbotGemini.test.js`), kept separate from widgets so it can be unit
/// tested directly.
class ChatFlow {
  ChatFlow({
    required this.isGeminiConfigured,
    this.knownTopicQueries = const {},
  });

  /// Whether the Gemini API key is present.
  final bool isGeminiConfigured;

  /// Example-query strings for the topic chips; a message matching one of
  /// these routes to the fixed-response lookup instead of Gemini.
  final Set<String> knownTopicQueries;

  int? pendingRank;
  String? pendingCategory;
  String pendingState = '';
  String pendingExamType = 'JEE Main';

  void reset() {
    pendingRank = null;
    pendingCategory = null;
    pendingState = '';
    pendingExamType = 'JEE Main';
  }

  /// Processes [text] and returns the routing decision, mutating the pending
  /// accumulators. On a completed prediction or a general query the pending
  /// state is reset (matching the web behavior).
  ChatFlowResult handle(String text) {
    final parsed = parseCollegeQuery(text);

    if (parsed.rank != null) pendingRank = parsed.rank;
    if (parsed.category != null) pendingCategory = parsed.category;
    if (parsed.state != null) pendingState = parsed.state!;
    if (parsed.examType != null) pendingExamType = parsed.examType!;

    final rank = parsed.rank ?? pendingRank;
    final category = parsed.category ?? pendingCategory;
    final stateForPrediction = parsed.state ?? pendingState;
    final examType = parsed.examType ?? pendingExamType;

    final hasAllParams = rank != null && category != null;
    final isRankQuery = parsed.isCollegeQuery || hasAllParams;

    if (isRankQuery) {
      if (rank == null || category == null) {
        // Keep pending state so the next turn can complete the query.
        return const ChatFlowResult(ChatFlowType.clarification);
      }
      final quota = examType == 'JEE Advanced' ? 'AI' : 'OS';
      final params = ChatPredictionParams(
        rank: rank,
        category: category,
        examType: examType,
        quota: quota,
        state: stateForPrediction,
      );
      reset();
      return ChatFlowResult(ChatFlowType.prediction, params: params);
    }

    // Not a rank query.
    reset();
    if (knownTopicQueries.contains(text)) {
      return const ChatFlowResult(ChatFlowType.fixedResponse);
    }
    if (isGeminiConfigured) {
      return const ChatFlowResult(ChatFlowType.gemini);
    }
    return const ChatFlowResult(ChatFlowType.fallback);
  }
}
