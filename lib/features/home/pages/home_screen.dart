import 'package:flutter/material.dart';

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
        children: const [
          HomeHeader(),
          HomeSearchBar(),
          QuickActions(),

          // 🔥 Trending
          SectionTitle(title: "🔥 Trending"),
          HorizontalList(
            section: HomeSection.trending,
          ),

          SizedBox(height: 20),

          // ⭐ Continue Watching
          SectionTitle(title: "⭐ Continue Watching"),
          HorizontalList(
            section: HomeSection.continueWatching,
          ),

          SizedBox(height: 20),

          // 🌸 This Season
          SectionTitle(title: "🌸 This Season"),
          HorizontalList(
            section: HomeSection.thisSeason,
          ),

          SizedBox(height: 20),

          // 🆕 Just Released
          SectionTitle(title: "🆕 Just Released"),
          HorizontalList(
            section: HomeSection.justReleased,
          ),

          SizedBox(height: 20),

          // 🏆 Popular This Week
          SectionTitle(title: "🏆 Popular This Week"),
          HorizontalList(
            section: HomeSection.popularThisWeek,
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}