import 'package:equatable/equatable.dart';

/// Who sent a chat message.
enum ChatRole { user, bot }

/// A suggested topic chip shown under the greeting / fallbacks.
/// Mirrors `initialCategoriesBase` + the translated label/example query.
class ChatTopic extends Equatable {
  const ChatTopic({
    required this.id,
    required this.topicId,
    required this.label,
    required this.exampleQuery,
  });

  final String id;
  final String topicId;
  final String label;

  /// The query text submitted when the chip is tapped (and used to match a
  /// `fixed_responses` row by `topic_id`).
  final String exampleQuery;

  @override
  List<Object?> get props => [id, topicId, label, exampleQuery];
}

/// A single message in the chat transcript.
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.content,
    this.suggestions,
    this.relatedContentSlug,
    this.showHowToUseSuggestion = false,
  });

  final ChatRole role;

  /// Markdown body (bot messages may contain links/lists).
  final String content;

  /// Topic chips to render under this (bot) message, if any.
  final List<ChatTopic>? suggestions;

  /// Slug for a "Learn more →" link, if the response references content.
  final String? relatedContentSlug;

  /// Whether to render the "see our How to Use Guide" helper box.
  final bool showHowToUseSuggestion;

  bool get isUser => role == ChatRole.user;

  ChatMessage copyWith({
    List<ChatTopic>? suggestions,
    bool clearSuggestions = false,
  }) {
    return ChatMessage(
      role: role,
      content: content,
      suggestions: clearSuggestions ? null : (suggestions ?? this.suggestions),
      relatedContentSlug: relatedContentSlug,
      showHowToUseSuggestion: showHowToUseSuggestion,
    );
  }

  @override
  List<Object?> get props =>
      [role, content, suggestions, relatedContentSlug, showHowToUseSuggestion];
}
