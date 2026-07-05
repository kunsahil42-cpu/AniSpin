import 'package:flutter/material.dart';

class DescriptionSection extends StatefulWidget {
  final String description;

  const DescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<DescriptionSection> createState() =>
      _DescriptionSectionState();
}

class _DescriptionSectionState
    extends State<DescriptionSection> {
  bool _expanded = false;

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll("&quot;", "\"")
        .replaceAll("&#039;", "'")
        .replaceAll("&amp;", "&")
        .replaceAll("&lt;", "<")
        .replaceAll("&gt;", ">");
  }

  @override
  Widget build(BuildContext context) {
    final description = _cleanText(widget.description);
    final theme = Theme.of(context);
    
    final descriptionStyle = theme.textTheme.bodyMedium?.copyWith(
      height: 1.6,
      letterSpacing: 0.15,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Synopsis",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          AnimatedCrossFade(
            firstChild: Text(
              description.isEmpty
                  ? "No synopsis available."
                  : description,
              maxLines: 5,
              overflow: TextOverflow.fade,
              style: descriptionStyle,
            ),
            secondChild: Text(
              description.isEmpty
                  ? "No synopsis available."
                  : description,
              style: descriptionStyle,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          if (description.length > 220)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                label: Text(
                  _expanded ? "Read Less" : "Read More",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}