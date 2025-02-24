import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedImage extends StatefulWidget {
  final double rotateX;
  final double rotateZ;
  final double scale;
  final bool mirror;
  final bool isAnimating;

  const AnimatedImage({
    super.key,
    required this.rotateX,
    required this.rotateZ,
    required this.scale,
    required this.mirror,
    required this.isAnimating,
  });

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  Timer? _timer;
  double _animatedRotateZ = 0.0;

  @override
  void didUpdateWidget(AnimatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        startAnimation();
      } else {
        stopAnimation();
      }
    }
  }

  void startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _animatedRotateZ += 0.05;
        if (_animatedRotateZ > 1.0) _animatedRotateZ = -1.0;
      });
    });
  }

  void stopAnimation() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(widget.rotateX)
          ..rotateZ(widget.isAnimating ? _animatedRotateZ : widget.rotateZ)
          ..scale(widget.mirror ? -widget.scale : widget.scale, widget.scale),
        alignment: Alignment.center,
        child: Image.network(
          'https://picsum.photos/512',
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}