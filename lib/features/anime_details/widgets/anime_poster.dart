import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Premium poster card used on Anime Details and Manga Details screens.
///
/// Sizing strategy: the image is pinned to [_posterWidth] pixels wide.
/// [BoxFit.fitWidth] scales it so the width fills exactly [_posterWidth] and
/// the height is derived from the image's own intrinsic aspect ratio —
/// guaranteeing that the full artwork is always visible without any cropping,
/// stretching, letterboxing, or empty space regardless of what AniList serves.
class AnimePoster extends StatelessWidget {
  final String imageUrl;

  static const double _posterWidth = 180;

  const AnimePoster({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Material handles elevation shadow + borderRadius + antiAlias clip
    // in a single widget, avoiding the shadow-gets-clipped pitfall.
    return Material(
      color: Colors.transparent,
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,

        // Width is fixed. BoxFit.fitWidth lets the height scale from the
        // image's own intrinsic dimensions — no forced container ratio.
        width: _posterWidth,
        fit: BoxFit.fitWidth,

        filterQuality: FilterQuality.medium,
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: Duration.zero,

        // Placeholder preserves approximate height while loading.
        placeholder: (context, url) => SizedBox(
          width: _posterWidth,
          height: _posterWidth * 1.42, // matches AniList large cover ratio
          child: Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF7C4DFF),
              ),
            ),
          ),
        ),

        errorWidget: (context, url, error) => SizedBox(
          width: _posterWidth,
          height: _posterWidth * 1.42,
          child: Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: Icon(
                Icons.broken_image_rounded,
                color: Colors.white38,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}