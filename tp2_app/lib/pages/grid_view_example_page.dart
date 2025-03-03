//exo 5a
import 'package:flutter/material.dart';

class GridViewExamplePage extends StatelessWidget {
  const GridViewExamplePage({super.key});

  // 定义颜色列表
  final List<Color> tileColors = const [
    Color(0xFF7FB3D5), // 浅蓝色 Tile 1
    Color(0xFF82E0AA), // 浅绿色 Tile 2
    Color(0xFF52BE80), // 绿色 Tile 3
    Color(0xFFCD6155), // 玫红色 Tile 4
    Color(0xFF6C3483), // 紫色 Tile 5
    Color(0xFF0000FF), // 蓝色 Tile 6
    Color(0xFFA93226), // 深红色 Tile 7
    Color(0xFF82E0AA), // 浅绿色 Tile 8
    Color(0xFF3498DB), // 蓝色 Tile 9
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.count(
              crossAxisCount: 3, // 3x3网格
              crossAxisSpacing: 2.0, // 水平间距
              mainAxisSpacing: 2.0, // 垂直间距
              physics: const NeverScrollableScrollPhysics(), // 禁用滚动
              children: List.generate(9, (index) {
                return Container(
                  color: tileColors[index],
                  child: Center(
                    child: Text(
                      'Tile ${index + 1}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
