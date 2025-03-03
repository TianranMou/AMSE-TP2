//ex2a，b
import 'package:flutter/material.dart';
import '../widgets/animated_image.dart';
import '../widgets/image_transform_controls.dart';

class ImageTransformPage extends StatefulWidget {
  const ImageTransformPage({
    super.key,
    required this.title,
    required this.animated,
  });

  final String title;
  final bool animated;

  @override
  State<ImageTransformPage> createState() => _ImageTransformPageState();
}

class _ImageTransformPageState extends State<ImageTransformPage> {
  double rotateX = 0.0;
  double rotateZ = 0.0;
  double scale = 1.0;
  bool mirror = false;
  bool isAnimating = false;

  void onRotateXChanged(double value) {
    setState(() => rotateX = value);
  }

  void onRotateZChanged(double value) {
    setState(() => rotateZ = value);
  }

  void onScaleChanged(double value) {
    setState(() => scale = value);
  }

  void onMirrorChanged(bool value) {
    setState(() => mirror = value);
  }

  void toggleAnimation() {
    if (widget.animated) {
      setState(() => isAnimating = !isAnimating);
    }
  }

  // 新增：接收动画值的回调
  void updateAnimationValues(
      double newRotateX, double newRotateZ, double newScale) {
    setState(() {
      rotateX = newRotateX;
      rotateZ = newRotateZ;
      scale = newScale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedImage(
                    rotateX: rotateX,
                    rotateZ: rotateZ,
                    scale: scale,
                    mirror: mirror,
                    isAnimating: isAnimating && widget.animated,
                    // 传递动画值更新回调
                    onAnimationValueChanged:
                        isAnimating ? updateAnimationValues : null,
                  ),
                  const SizedBox(height: 20),
                  ImageTransformControls(
                    rotateX: rotateX,
                    rotateZ: rotateZ,
                    scale: scale,
                    mirror: mirror,
                    onRotateXChanged:
                        isAnimating ? null : onRotateXChanged, // 动画中禁用滑块交互
                    onRotateZChanged: isAnimating ? null : onRotateZChanged,
                    onScaleChanged: isAnimating ? null : onScaleChanged,
                    onMirrorChanged: onMirrorChanged, // 镜像控制不受动画影响
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.animated
          ? FloatingActionButton(
              onPressed: toggleAnimation,
              child: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
            )
          : null,
    );
  }
}
