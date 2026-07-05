import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/models/reading_progress.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../manga_details/models/chapter_model.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  final int mangaId;
  final int chapterNumber;
  
  // Passed details via GoRouter extra
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int totalChapters;

  const MangaReaderScreen({
    super.key,
    required this.mangaId,
    required this.chapterNumber,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.totalChapters,
  });

  @override
  ConsumerState<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends ConsumerState<MangaReaderScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;
  late ChapterModel _chapter;
  
  bool _isHorizontal = true; // Layout toggle
  bool _showOverlays = true;
  int _currentPage = 1;
  int _totalPages = 12;

  // Zoom parameters
  final Map<int, TransformationController> _transformationControllers = {};

  @override
  void initState() {
    super.initState();
    _chapter = ChapterModel.mock(widget.mangaId, widget.chapterNumber);
    _totalPages = _chapter.pages.length;
    _pageController = PageController();
    _scrollController = ScrollController();
    
    // Configure immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Initial progress save
    _saveReadingProgress();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index + 1;
    });
    
    // Save progress
    _saveReadingProgress();

    // Preload next page
    if (index + 1 < _totalPages) {
      precacheImage(
        CachedNetworkImageProvider(_chapter.pages[index + 1]),
        context,
      );
    }
  }

  void _saveReadingProgress() {
    final repo = ref.read(readingProgressRepositoryProvider);
    final percentage = _currentPage / _totalPages;

    final progress = ReadingProgress()
      ..mangaId = widget.mangaId
      ..romajiTitle = widget.romajiTitle
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..totalChapters = widget.totalChapters
      ..lastReadChapter = widget.chapterNumber
      ..lastReadPage = _currentPage
      ..readingPercentage = percentage
      ..lastReadAt = DateTime.now();

    // Mark as completed if read last page
    if (_currentPage == _totalPages) {
      final completed = List<int>.from(progress.completedChapters);
      if (!completed.contains(widget.chapterNumber)) {
        completed.add(widget.chapterNumber);
        progress.completedChapters = completed;
      }
    }

    repo.saveProgress(progress).then((_) {
      ref.invalidate(mangaProgressProvider(widget.mangaId));
      ref.invalidate(continueReadingProvider);
    });
  }

  void _toggleOverlays() {
    setState(() {
      _showOverlays = !_showOverlays;
    });
  }

  void _doubleTapZoom(int pageIndex) {
    final controller = _transformationControllers.putIfAbsent(
      pageIndex,
      () => TransformationController(),
    );

    if (controller.value != Matrix4.identity()) {
      controller.value = Matrix4.identity();
    } else {
      // Zoom in 2.5x centered
      controller.value = Matrix4.identity()
        ..setEntry(0, 3, -150.0)
        ..setEntry(1, 3, -200.0)
        ..setEntry(0, 0, 2.5)
        ..setEntry(1, 1, 2.5);
    }
    setState(() {});
  }

  void _navigateToChapter(int targetChapter) {
    if (targetChapter < 1 || targetChapter > widget.totalChapters) return;

    context.pushReplacement(
      '/manga/${widget.mangaId}/read/$targetChapter',
      extra: {
        'romajiTitle': widget.romajiTitle,
        'englishTitle': widget.englishTitle,
        'coverImage': widget.coverImage,
        'bannerImage': widget.bannerImage,
        'totalChapters': widget.totalChapters,
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    for (var c in _transformationControllers.values) {
      c.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Reader Content
          GestureDetector(
            onTap: _toggleOverlays,
            child: _isHorizontal ? _buildHorizontalReader() : _buildVerticalReader(),
          ),

          // Header Overlay
          if (_showOverlays)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xE6000000), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.romajiTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Chapter ${widget.chapterNumber} / ${widget.totalChapters}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isHorizontal ? Icons.view_headline_rounded : Icons.view_carousel_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isHorizontal = !_isHorizontal;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Navigation Overlay
          if (_showOverlays)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xE6000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Chapter navigator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: widget.chapterNumber > 1
                              ? () => _navigateToChapter(widget.chapterNumber - 1)
                              : null,
                        ),
                        Text(
                          'Page $_currentPage of $_totalPages',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: widget.chapterNumber < widget.totalChapters
                              ? () => _navigateToChapter(widget.chapterNumber + 1)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress Slider
                    if (_isHorizontal)
                      Slider(
                        activeColor: const Color(0xFF7C4DFF),
                        inactiveColor: Colors.white24,
                        value: _currentPage.toDouble(),
                        min: 1.0,
                        max: _totalPages.toDouble(),
                        divisions: _totalPages - 1,
                        onChanged: (val) {
                          _pageController.jumpToPage(val.toInt() - 1);
                        },
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalReader() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: _totalPages,
      itemBuilder: (context, index) {
        final controller = _transformationControllers.putIfAbsent(
          index,
          () => TransformationController(),
        );

        return Center(
          child: InteractiveViewer(
            transformationController: controller,
            minScale: 1.0,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTap: () => _doubleTapZoom(index),
              child: CachedNetworkImage(
                imageUrl: _chapter.pages[index],
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, size: 60, color: Colors.white30),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalReader() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (_scrollController.hasClients) {
          final extent = _scrollController.position.pixels;
          final max = _scrollController.position.maxScrollExtent;
          if (max > 0) {
            final page = ((extent / max) * _totalPages).clamp(1.0, _totalPages.toDouble()).toInt();
            if (page != _currentPage) {
              setState(() {
                _currentPage = page;
              });
              _saveReadingProgress();
            }
          }
        }
        return false;
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 80),
        itemCount: _totalPages,
        separatorBuilder: (_, __) => const Divider(height: 20, color: Colors.white10),
        itemBuilder: (context, index) {
          final controller = _transformationControllers.putIfAbsent(
            index,
            () => TransformationController(),
          );

          return InteractiveViewer(
            transformationController: controller,
            minScale: 1.0,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTap: () => _doubleTapZoom(index),
              child: CachedNetworkImage(
                imageUrl: _chapter.pages[index],
                fit: BoxFit.fitWidth,
                placeholder: (_, __) => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF))),
                ),
                errorWidget: (_, __, ___) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white30)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
