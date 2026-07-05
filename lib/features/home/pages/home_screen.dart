import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../enums/home_section.dart';
import '../widgets/home_header.dart';
import '../widgets/horizontal_list.dart';
import '../widgets/quick_actions.dart';
import '../widgets/search_bar.dart';
import '../widgets/section_title.dart';
import '../widgets/continue_watching_list.dart';
import '../providers/home_provider.dart';
import '../../manga_home/pages/manga_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeType = ref.watch(homeTypeProvider);

    return Scaffold(
      body: ListView(
        children: [
          const HomeHeader()
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2),

          if (homeType == HomeType.anime) ...[
            const HomeSearchBar()
                .animate()
                .fadeIn(
                  delay: 100.ms,
                  duration: 400.ms,
                )
                .slideY(begin: -0.2),

            const QuickActions()
                .animate()
                .fadeIn(
                  delay: 200.ms,
                  duration: 400.ms,
                )
                .slideY(begin: -0.2),

            // Real Continue Watching section from Isar
            const SectionTitle(
              title: "⭐ Continue Watching",
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideX(begin: -0.1),

            const ContinueWatchingList().animate().fadeIn(delay: 350.ms),

            const SizedBox(height: 10),

            const SectionTitle(
              title: "🔥 Trending Now",
            )
                .animate()
                .fadeIn(delay: 400.ms)
                .slideX(begin: -0.1),

            const HorizontalList(
              section: HomeSection.trending,
            ).animate().fadeIn(delay: 450.ms),

            const SizedBox(height: 20),

            const SectionTitle(
              title: "🌸 This Season",
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .slideX(begin: -0.1),

            const HorizontalList(
              section: HomeSection.thisSeason,
            ).animate().fadeIn(delay: 550.ms),

            const SizedBox(height: 20),

            const SectionTitle(
              title: "🆕 Just Released",
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .slideX(begin: -0.1),

            const HorizontalList(
              section: HomeSection.justReleased,
            ).animate().fadeIn(delay: 650.ms),

            const SizedBox(height: 20),

            const SectionTitle(
              title: "🏆 Popular This Week",
            )
                .animate()
                .fadeIn(delay: 700.ms)
                .slideX(begin: -0.1),

            const HorizontalList(
              section: HomeSection.popularThisWeek,
            ).animate().fadeIn(delay: 750.ms),

            const SizedBox(height: 30),
          ] else ...[
            // Embedded Manga Home screen
            const MangaHomeScreen(embed: true)
                .animate()
                .fadeIn(duration: 400.ms),
          ],
        ],
      ),
    );
  }
}