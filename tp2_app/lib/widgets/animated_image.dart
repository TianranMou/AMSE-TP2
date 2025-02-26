import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class AnimatedImage extends StatefulWidget {
  final double rotateX;
  final double rotateZ;
  final double scale;
  final bool mirror;
  final bool isAnimating;
  final Function(double, double, double)? onAnimationValueChanged;

  const AnimatedImage({
    super.key,
    required this.rotateX,
    required this.rotateZ,
    required this.scale,
    required this.mirror,
    required this.isAnimating,
    this.onAnimationValueChanged,
  });

  @override
  State<AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  Timer? _timer;
  double _animatedRotateX = 0.0;
  double _animatedRotateZ = 0.0;
  double _animatedScale = 1.0;
  bool _scaleIncreasing = true;

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
        // RotateX: 完整360度旋转（在滑块上显示为-1到1的范围）
        _animatedRotateX += 0.05;
        if (_animatedRotateX > 2 * math.pi) {
          _animatedRotateX = 0.0;
        }
        
        // RotateZ: 完整360度旋转，速度稍快
        _animatedRotateZ += 0.07;
        if (_animatedRotateZ > 2 * math.pi) {
          _animatedRotateZ = 0.0;
        }
        
        // Scale: 在0.5和2.0之间来回
        if (_scaleIncreasing) {
          _animatedScale += 0.04;
          if (_animatedScale >= 2.0) {
            _animatedScale = 2.0;
            _scaleIncreasing = false;
          }
        } else {
          _animatedScale -= 0.04;
          if (_animatedScale <= 0.5) {
            _animatedScale = 0.5;
            _scaleIncreasing = true;
          }
        }
        
        // 将当前动画值报告回父组件（将弧度值转换为-1到1的范围用于滑块显示）
        if (widget.onAnimationValueChanged != null) {
          widget.onAnimationValueChanged!(
            ((_animatedRotateX / math.pi) - 1.0).clamp(-1.0, 1.0), 
            ((_animatedRotateZ / math.pi) - 1.0).clamp(-1.0, 1.0), 
            _animatedScale
          );
        }
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
    // 使用动画值或用户手动设置的值
    // 将滑块的-1到1范围转换为实际的弧度值
    final double actualRotateX = widget.isAnimating 
        ? _animatedRotateX 
        : (widget.rotateX + 1.0) * math.pi;
    final double actualRotateZ = widget.isAnimating 
        ? _animatedRotateZ 
        : (widget.rotateZ + 1.0) * math.pi;
    final double scale = widget.isAnimating ? _animatedScale : widget.scale;

    return Container(
      height: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(actualRotateX)
          ..rotateZ(actualRotateZ)
          ..scale(widget.mirror ? -scale : scale, scale),
        alignment: Alignment.center,
        child: Image.network(
          'https://picsum.photos/512',
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('Error loading image'));
          },
        ),
      ),
    );
  }
}