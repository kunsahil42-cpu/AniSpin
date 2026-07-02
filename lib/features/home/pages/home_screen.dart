import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../enums/home_section.dart';
import '../widgets/home_header.dart';
import '../widgets/horizontal_list.dart';
import '../widgets/quick_actions.dart';
import '../widgets/search_bar.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeHeader()
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2),

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

          const SectionTitle(
            title: "🔥 Trending",
          )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: -0.1),

          const HorizontalList(
            section: HomeSection.trending,
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 20),

          const SectionTitle(
            title: "⭐ Continue Watching",
          )
              .animate()
              .fadeIn(delay: 450.ms)
              .slideX(begin: -0.1),

          const HorizontalList(
            section: HomeSection.continueWatching,
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 20),

          const SectionTitle(
            title: "🌸 This Season",
          )
              .animate()
              .fadeIn(delay: 600.ms)
              .slideX(begin: -0.1),

          const HorizontalList(
            section: HomeSection.thisSeason,
          ).animate().fadeIn(delay: 650.ms),

          const SizedBox(height: 20),

          const SectionTitle(
            title: "🆕 Just Released",
          )
              .animate()
              .fadeIn(delay: 750.ms)
              .slideX(begin: -0.1),

          const HorizontalList(
            section: HomeSection.justReleased,
          ).animate().fadeIn(delay: 800.ms),

          const SizedBox(height: 20),

          const SectionTitle(
            title: "🏆 Popular This Week",
          )
              .animate()
              .fadeIn(delay: 900.ms)
              .slideX(begin: -0.1),

          const HorizontalList(
            section: HomeSection.popularThisWeek,
          ).animate().fadeIn(delay: 950.ms),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}