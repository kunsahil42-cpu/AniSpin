import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
              Container(
                height: 80,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}