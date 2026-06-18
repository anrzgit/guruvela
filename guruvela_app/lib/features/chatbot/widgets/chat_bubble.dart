import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/language_provider.dart';
import '../../shared/widgets/markdown_view.dart';
import '../../../data/models/chat_message.dart';

/// Renders a single chat message: user bubbles (primary, right-aligned) and
/// bot bubbles (surface, left-aligned) with optional markdown, a "Learn more"
/// link, a how-to-use helper box, and topic-suggestion chips.
class ChatBubble extends ConsumerWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.onTopicTap,
  });

  final ChatMessage message;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.isUser;
    final scheme = context.scheme;
    final s = ref.watch(stringsProvider);

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.82,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUser ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.md),
          topRight: const Radius.circular(AppRadius.md),
          bottomLeft: Radius.circular(isUser ? AppRadius.md : 4),
          bottomRight: Radius.circular(isUser ? 4 : AppRadius.md),
        ),
        border: isUser ? null : Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUser)
            Text(
              message.content,
              style: context.text.bodyMedium?.copyWith(color: Colors.white),
            )
          else
            MarkdownView(message.content, selectable: false),

          // "Learn more →"
          if (!isUser && message.relatedContentSlug != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: InkWell(
                onTap: () => _openRelated(context, message.relatedContentSlug!),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Learn more',
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        size: 14, color: context.colors.accent),
                  ],
                ),
              ),
            ),

          // How-to-use helper box
          if (!isUser && message.showHowToUseSuggestion)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: InkWell(
                onTap: () => context.go(AppRoutes.howToUse),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: context.text.bodySmall,
                      children: [
                        const TextSpan(
                            text: 'For more help, see our '),
                        TextSpan(
                          text: 'How to Use Guide',
                          style: TextStyle(
                            color: context.colors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Topic suggestion chips
          if (!isUser &&
              message.suggestions != null &&
              message.suggestions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.chatPickTopic, style: context.text.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final t in message.suggestions!)
                        ActionChip(
                          label: Text(t.label),
                          onPressed: () => onTopicTap(t.exampleQuery),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      ),
    );
  }

  void _openRelated(BuildContext context, String slug) {
    if (slug == 'josaa-comprehensive-faq') {
      context.go(AppRoutes.faqs);
    } else {
      context.go(AppRoutes.contentPage(slug));
    }
  }
}
