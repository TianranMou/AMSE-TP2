// exo 5b
import 'package:flutter/material.dart';

class ImageGridPage extends StatelessWidget {
  const ImageGridPage({super.key});

  final String imageUrl = 'https://picsum.photos/512';

  @override
  Widget build(BuildContext context) {
    const int size = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Board'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(builder: (context, constraints) {
              final tileSize = constraints.maxWidth / size;

              return GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  // 计算当前瓦片在网格中的行列位置
                  final row = index ~/ size;
                  final col = index % size;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: ClipRect(
                      child: SizedBox(
                        width: tileSize,
                        height: tileSize,
                        child: FittedBox(
                          fit: BoxFit.none,
                          clipBehavior: Clip.hardEdge,
                          alignment: FractionalOffset(
                            size == 1 ? 0.5 : col / (size - 1),
                            size == 1 ? 0.5 : row / (size - 1),
                          ),
                          child: SizedBox(
                            width: tileSize * size,
                            height: tileSize * size,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.error));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
