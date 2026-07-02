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
      height: 220,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black26,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return Container(
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.broken_image,
                size: 60,
              ),
            );
          },
        ),
      ),
    );
  }
}