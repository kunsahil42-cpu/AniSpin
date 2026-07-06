import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/states/empty_state.dart';
import '../models/anime_model.dart';
import '../models/manga_model.dart';
import '../providers/search_provider.dart';
import '../widgets/anime_tile.dart';
import '../widgets/manga_tile.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_field.dart';

class SearchScreen extends ConsumerStatefulWidget {
  /// Whether the Manga tab should be selected when the screen opens.
  final bool initialIsManga;

  const SearchScreen({super.key, this.initialIsManga = false});

  @override
  ConsumerState<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends ConsumerState<SearchScreen> {
  final TextEditingController _controller =
      TextEditingController();

  String _query = '';
  late bool _isManga = widget.initialIsManga;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = _isManga
        ? ref.watch(mangaSearchProvider(_query))
        : ref.watch(animeSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: Text(_isManga ? "Search Manga" : "Search Anime"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Anime'),
                  icon: Icon(Icons.movie_outlined),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Manga'),
                  icon: Icon(Icons.book_outlined),
                ),
              ],
              selected: {_isManga},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _isManga = newSelection.first;
                });
              },
            ),
          ),
          SearchField(
            controller: _controller,
            onChanged: () {
              setState(() {
                _query = _controller.text;
              });
            },
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? const EmptyWidget()
                : AsyncNetworkView(
                    value: searchResult,
                    loading: () => const LoadingWidget(),
                    onRetry: () => ref.invalidate(
                      _isManga
                          ? mangaSearchProvider(_query)
                          : animeSearchProvider(_query),
                    ),
                    data: (results) {
                      if (results.isEmpty) {
                        return EmptyState(
                          title: _isManga ? "No Manga Found" : "No Anime Found",
                          subtitle:
                              "Try searching with a different keyword.",
                          icon:
                              Icons.search_off_rounded,
                        );
                      }

                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder:
                            (context, index) {
                          final item = results[index];
                          if (item is MangaModel) {
                            return MangaTile(manga: item);
                          } else if (item is AnimeModel) {
                            return AnimeTile(anime: item);
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}