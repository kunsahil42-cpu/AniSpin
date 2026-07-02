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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            "Synopsis",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
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
              style:
                  Theme.of(context).textTheme.bodyMedium,
            ),
            secondChild: Text(
              description.isEmpty
                  ? "No synopsis available."
                  : description,
              style:
                  Theme.of(context).textTheme.bodyMedium,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration:
                const Duration(milliseconds: 300),
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
                  _expanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                ),
                label: Text(
                  _expanded
                      ? "Read Less"
                      : "Read More",
                ),
              ),
            ),
        ],
      ),
    );
  }
}