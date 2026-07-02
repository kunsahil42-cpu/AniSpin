import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimePoster extends StatelessWidget {
  final String imageUrl;

  const AnimePoster({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade800,
            child: const Center(
              child: Icon(
                Icons.movie_rounded,
                color: Colors.white54,
                size: 70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}