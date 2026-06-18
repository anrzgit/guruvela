import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/language_provider.dart';
import '../view_models/chat_view_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/predictor_promo.dart';

/// Full-screen chat assistant — port of `ChatInterface.jsx`.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? direct]) {
    final text = direct ?? _input.text;
    if (text.trim().isEmpty) return;
    ref.read(chatViewModelProvider.notifier).send(text);
    if (direct == null) _input.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);
    final vm = ref.read(chatViewModelProvider.notifier);
    final s = ref.watch(stringsProvider);

    // Auto-scroll when a new message lands.
    ref.listen(chatViewModelProvider, (prev, next) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: context.scheme.primary.withValues(alpha: 0.15),
              child: Text(
                'G',
                style: TextStyle(
                  color: context.scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(s.chatAssistantTitle, style: context.text.titleMedium),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('Online',
                        style: context.text.bodySmall?.copyWith(
                          color: const Color(0xFF16A34A),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: vm.reset,
            child: Text(s.chatReset),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.showPredictorPromo)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: PredictorPromo(
                onOpen: () {
                  vm.dismissPromo();
                  context.go(AppRoutes.josaaPredictor);
                },
                onClose: vm.dismissPromo,
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.messages.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= state.messages.length) {
                  return const _TypingIndicator();
                }
                return ChatBubble(
                  message: state.messages[i],
                  onTopicTap: _send,
                );
              },
            ),
          ),
          _InputBar(
            controller: _input,
            isLoading: state.isLoading,
            placeholder: s.chatPlaceholder,
            onSend: () => _send(),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.placeholder,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final String placeholder;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          border: Border(top: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isLoading,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(hintText: placeholder),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              height: 52,
              width: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSend,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
