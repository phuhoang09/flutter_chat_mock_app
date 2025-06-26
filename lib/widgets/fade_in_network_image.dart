import 'package:flutter/material.dart';

class FadeInNetworkImage extends StatefulWidget {
  final String url;
  final double width;
  final double height;

  const FadeInNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  State<FadeInNetworkImage> createState() => _FadeInNetworkImageState();
}

class _FadeInNetworkImageState extends State<FadeInNetworkImage> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _loaded ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: Image.network(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            Future.microtask(() {
              if (mounted) {
                setState(() {
                  _loaded = true;
                });
              }
            });
          }
          return child;
        },
      ),
    );
  }
}
