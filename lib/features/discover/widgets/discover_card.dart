import 'package:flutter/material.dart';

class DiscoverCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const DiscoverCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}