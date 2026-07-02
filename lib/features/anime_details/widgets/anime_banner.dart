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
    final hasBanner =
        imageUrl.trim().isNotEmpty &&
        imageUrl != "null";

    return SizedBox(
      height: 300,
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
                color: Colors.grey.shade900,
              ),
              errorWidget: (context, url, _) => Container(
                color: Colors.grey.shade900,
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
              color: Colors.grey.shade900,
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
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          // Premium gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x22000000),
                    Color(0x88000000),
                    Color(0xDD000000),
                    Color(0xFF0F1117),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}