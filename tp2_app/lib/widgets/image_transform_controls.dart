import 'package:flutter/material.dart';

class ImageTransformControls extends StatelessWidget {
  final double rotateX;
  final double rotateZ;
  final double scale;
  final bool mirror;
  final ValueChanged<double>? onRotateXChanged;
  final ValueChanged<double>? onRotateZChanged;
  final ValueChanged<double>? onScaleChanged;
  final ValueChanged<bool> onMirrorChanged;

  const ImageTransformControls({
    super.key,
    required this.rotateX,
    required this.rotateZ,
    required this.scale,
    required this.mirror,
    required this.onRotateXChanged,
    required this.onRotateZChanged,
    required this.onScaleChanged,
    required this.onMirrorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAnimating = onRotateXChanged == null; // 通过回调是否为null判断动画状态

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rotate X: ${rotateX.toStringAsFixed(2)}'),
            Slider(
              value: rotateX,
              min: -1.0,
              max: 1.0,
              onChanged: onRotateXChanged,
              activeColor: isAnimating ? Colors.grey : null, // 动画时变灰
            ),
            Text('Rotate Z: ${rotateZ.toStringAsFixed(2)}'),
            Slider(
              value: rotateZ,
              min: -1.0,
              max: 1.0,
              onChanged: onRotateZChanged,
              activeColor: isAnimating ? Colors.grey : null,
            ),
            Text('Scale: ${scale.toStringAsFixed(2)}'),
            Slider(
              value: scale,
              min: 0.5,
              max: 2.0,
              onChanged: onScaleChanged,
              activeColor: isAnimating ? Colors.grey : null,
            ),
            CheckboxListTile(
              title: const Text('Mirror'),
              value: mirror,
              onChanged: (value) => onMirrorChanged(value ?? false),
            ),
          ],
        ),
      ),
    );
  }
}