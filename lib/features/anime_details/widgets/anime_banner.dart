import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeBanner extends StatelessWidget {
  final String imageUrl;

  const AnimeBanner({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final hasBanner =
        imageUrl.trim().isNotEmpty &&
        imageUrl != "null";

    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasBanner)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(
                milliseconds: 350,
              ),
              placeholder: (context, url) => Container(
                color: bgColor,
              ),
              errorWidget: (context, url, _) => Container(
                color: bgColor,
                child: const Center(
                  child: Icon(
                    Icons.movie_rounded,
                    color: Colors.white54,
                    size: 70,
                  ),
                ),
              ),
            )
          else
            Container(
              color: bgColor,
              child: const Center(
                child: Icon(
                  Icons.movie_rounded,
                  color: Colors.white54,
                  size: 70,
                ),
              ),
            ),

          // Cinematic blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.5,
                sigmaY: 1.5,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          // Premium gradient fading into background color dynamically
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    bgColor.withValues(alpha: 0.2),
                    bgColor.withValues(alpha: 0.65),
                    bgColor.withValues(alpha: 0.9),
                    bgColor,
                  ],
                  stops: const [0.0, 0.4, 0.7, 0.9, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}