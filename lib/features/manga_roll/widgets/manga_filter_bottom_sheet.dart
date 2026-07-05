import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/manga_roll_provider.dart';

class MangaFilterBottomSheet extends ConsumerStatefulWidget {
  const MangaFilterBottomSheet({super.key});

  @override
  ConsumerState<MangaFilterBottomSheet> createState() =>
      _MangaFilterBottomSheetState();
}

class _MangaFilterBottomSheetState
    extends ConsumerState<MangaFilterBottomSheet> {
  String? _selectedGenre;
  String? _selectedFormat;
  int? _minScore;

  final List<String> _genres = [
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Fantasy",
    "Romance",
    "Horror",
    "Mystery",
    "Psychological",
    "Sci-Fi",
    "Sports",
    "Music",
    "Slice of Life",
    "Supernatural",
  ];

  final List<String> _formats = [
    "MANGA",
    "NOVEL",
    "ONE_SHOT",
  ];

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(mangaRollFiltersProvider);
    _selectedGenre = currentFilters.genre;
    _selectedFormat = currentFilters.format;
    _minScore = currentFilters.minScore;
  }

  void _resetFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedFormat = null;
      _minScore = null;
    });
  }

  void _applyFilters() {
    ref.read(mangaRollFiltersProvider.notifier).state = MangaRollFilters(
      genre: _selectedGenre,
      format: _selectedFormat,
      minScore: _minScore,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Manga Roll",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: const Text("Reset All"),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre Section
                  Text(
                    "Genre",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _genres.map((genre) {
                      final isSelected = _selectedGenre == genre;
                      return ChoiceChip(
                        label: Text(genre),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGenre = selected ? genre : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Format Section
                  Text(
                    "Format",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _formats.map((format) {
                      final isSelected = _selectedFormat == format;
                      return ChoiceChip(
                        label: Text(format.replaceAll('_', ' ')),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFormat = selected ? format : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Minimum Score Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Minimum Score",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _minScore != null ? "${_minScore}%" : "Any",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: (_minScore ?? 0).toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: _minScore != null ? "${_minScore}%" : "Any",
                    onChanged: (value) {
                      setState(() {
                        _minScore = value == 0 ? null : value.round();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Apply button
          FilledButton(
            onPressed: _applyFilters,
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}
