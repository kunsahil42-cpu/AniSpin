import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
  });

  @override
  State<FavoriteButton> createState() =>
      _FavoriteButtonState();
}

class _FavoriteButtonState
    extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;

  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _scale = Tween<double>(
      begin: 1,
      end: 1.25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FilledButton.icon(
        onPressed: _toggle,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Icon(
            _isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            key: ValueKey(_isFavorite),
          ),
        ),
        label: Text(
          _isFavorite
              ? "Saved"
              : "Favorite",
        ),
      ),
    );
  }
}