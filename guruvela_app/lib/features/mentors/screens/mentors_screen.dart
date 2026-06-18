import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/page_hero.dart';
import '../../shared/widgets/state_views.dart';
import '../../shared/widgets/whatsapp_button.dart';
import '../view_models/mentors_providers.dart';
import '../widgets/mentor_card.dart';

/// Grid of active mentors — port of `MentorsPage.jsx`.
class MentorsScreen extends ConsumerWidget {
  const MentorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentors = ref.watch(mentorsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mentors')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(mentorsProvider.future),
        child: mentors.when(
          loading: () => const _Scrollable(child: SizedBox(
            height: 400,
            child: LoadingView(message: 'Loading mentors...'),
          )),
          error: (e, _) => _Scrollable(
            child: SizedBox(
              height: 400,
              child: ErrorRetryView(
                message: 'Could not load mentors.',
                onRetry: () => ref.invalidate(mentorsProvider),
              ),
            ),
          ),
          data: (list) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: PageHero(
                  title: 'Connect with Our Mentors',
                  subtitle:
                      'Get personalised guidance from students who have walked '
                      'the same path. Browse by branch and state.',
                  icon: Icons.people_outline,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 380,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisExtent: 270,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => MentorCard(mentor: list[i]),
                    childCount: list.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.xl,
                ),
                sliver: SliverToBoxAdapter(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Other Mentorship Options',
                            style: context.text.titleLarge),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'For general guidance in a group setting, join our '
                          'community.',
                          style: context.text.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const WhatsappButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps non-grid states so RefreshIndicator + scroll physics still apply.
class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [child],
    );
  }
}
