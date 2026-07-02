import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimeCard extends StatelessWidget {
  final int animeId;
  final String title;
  final String rating;
  final String episodes;
  final String imageUrl;

  const AnimeCard({
    super.key,
    required this.animeId,
    required this.title,
    required this.rating,
    required this.episodes,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push('/anime/$animeId');
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.deepPurple,
                      child: const Center(
                        child: Icon(
                          Icons.movie,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("⭐ $rating"),
                    Text("$episodes Episodes"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}