import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/app_language.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/utils/chat_flow.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/predictor_query.dart';
import '../../../data/repositories/predictor_repository.dart';
import '../../../data/static_data/chat_topics_data.dart';
import '../../../providers/core_providers.dart';
import '../../../providers/language_provider.dart';

/// Chat transcript + loading flag.
class ChatState {
  const ChatState({
    required this.messages,
    this.isLoading = false,
    this.showPredictorPromo = true,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final bool showPredictorPromo;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? showPredictorPromo,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      showPredictorPromo: showPredictorPromo ?? this.showPredictorPromo,
    );
  }
}

/// Drives the chatbot. Mirrors `ChatInterface.jsx`'s `handleSubmit`:
/// parse → route via [ChatFlow] → fetch predictions / Gemini / fixed response
/// → append a bot message (clearing prior suggestion chips).
class ChatViewModel extends AutoDisposeNotifier<ChatState> {
  late ChatFlow _flow;
  late List<ChatTopic> _topics;

  @override
  ChatState build() {
    final lang = ref.watch(languageProvider);
    _topics = ChatTopicsData.forLanguage(lang);
    _flow = ChatFlow(
      isGeminiConfigured: ref.read(geminiServiceProvider).isConfigured,
      knownTopicQueries: _topics.map((t) => t.exampleQuery).toSet(),
    );
    final strings = AppStrings(lang);
    return ChatState(
      messages: [
        ChatMessage(
          role: ChatRole.bot,
          content: strings.chatGreeting,
          suggestions: _topics,
        ),
      ],
    );
  }

  AppLanguage get _lang => ref.read(languageProvider);
  AppStrings get _strings => AppStrings(_lang);

  void dismissPromo() => state = state.copyWith(showPredictorPromo: false);

  void reset() {
    _flow.reset();
    state = ChatState(
      messages: [
        ChatMessage(
          role: ChatRole.bot,
          content: _strings.chatGreeting,
          suggestions: _topics,
        ),
      ],
      showPredictorPromo: state.showPredictorPromo,
    );
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    // Append the user message and clear chips on previous bot messages.
    final cleared = state.messages
        .map((m) => m.isUser ? m : m.copyWith(clearSuggestions: true))
        .toList();
    state = state.copyWith(
      messages: [
        ...cleared,
        ChatMessage(role: ChatRole.user, content: trimmed),
      ],
      isLoading: true,
    );

    final result = _flow.handle(trimmed);
    final bot = await _buildBotMessage(trimmed, result);

    state = state.copyWith(
      messages: [...state.messages, bot],
      isLoading: false,
    );
  }

  Future<ChatMessage> _buildBotMessage(
    String text,
    ChatFlowResult result,
  ) async {
    final strings = _strings;
    switch (result.type) {
      case ChatFlowType.clarification:
        return ChatMessage(
          role: ChatRole.bot,
          content: strings.chatNeedInfo,
        );

      case ChatFlowType.prediction:
        return _predictionMessage(result.params!);

      case ChatFlowType.fixedResponse:
        return _fixedResponseMessage(text);

      case ChatFlowType.gemini:
        final answer = await ref
            .read(geminiServiceProvider)
            .getGenerativeResponse(text, _lang);
        return ChatMessage(role: ChatRole.bot, content: answer);

      case ChatFlowType.fallback:
        // No Gemini → try the keyword/fixed-response path, else generic.
        return _fixedResponseMessage(text, fallbackToGeneric: true);
    }
  }

  Future<ChatMessage> _predictionMessage(ChatPredictionParams p) async {
    final strings = _strings;
    try {
      final query = PredictorQuery(
        examType: p.examType,
        rank: '${p.rank}',
        category: p.category,
        gender: 'Gender-Neutral',
        quota: p.quota,
        state: p.state.isEmpty ? null : p.state,
      );
      final colleges = await ref.read(predictorRepositoryProvider).fetchJosaa(query);
      colleges.sort((a, b) => a.closingRank.compareTo(b.closingRank));
      final top = colleges.take(3).toList();
      if (top.isEmpty) {
        return ChatMessage(
          role: ChatRole.bot,
          content: strings.chatFallback,
          relatedContentSlug: 'josaa-comprehensive-faq',
          showHowToUseSuggestion: true,
          suggestions: _topics,
        );
      }
      final lines = top
          .map((c) => '🎓 ${c.instituteName} – ${c.branchName} (${c.quota})')
          .join('\n');
      final content =
          '${strings.chatTopColleges}\n$lines\n\n_${strings.chatViewFullList}_';
      return ChatMessage(role: ChatRole.bot, content: content);
    } on PredictorValidationException catch (e) {
      return ChatMessage(role: ChatRole.bot, content: e.message);
    } catch (_) {
      return ChatMessage(role: ChatRole.bot, content: strings.chatError);
    }
  }

  Future<ChatMessage> _fixedResponseMessage(
    String text, {
    bool fallbackToGeneric = false,
  }) async {
    final strings = _strings;
    // Map the tapped chip's example query back to its topicId.
    final topic = _topics.where((t) => t.exampleQuery == text).firstOrNull;
    if (topic != null) {
      final resp = await ref
          .read(chatRepositoryProvider)
          .fetchFixedResponse(topic.topicId, _lang.code);
      if (resp != null) {
        return ChatMessage(
          role: ChatRole.bot,
          content: resp.answer,
          relatedContentSlug: resp.relatedSlug,
          showHowToUseSuggestion: resp.showHowToUse,
        );
      }
    }
    // No match → generic fallback with topic chips + how-to-use helper.
    return ChatMessage(
      role: ChatRole.bot,
      content: strings.chatFallback,
      relatedContentSlug: 'josaa-comprehensive-faq',
      showHowToUseSuggestion: true,
      suggestions: _topics,
    );
  }
}

final chatViewModelProvider =
    AutoDisposeNotifierProvider<ChatViewModel, ChatState>(ChatViewModel.new);
