//exo 5a
import 'package:flutter/material.dart';

class GridViewExamplePage extends StatelessWidget {
  const GridViewExamplePage({super.key});

  final List<Color> tileColors = const [
    Color(0xFF7FB3D5),
    Color(0xFF82E0AA),
    Color(0xFF52BE80),
    Color(0xFFCD6155),
    Color(0xFF6C3483),
    Color(0xFF0000FF),
    Color(0xFFA93226),
    Color(0xFF82E0AA),
    Color(0xFF3498DB),
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
              crossAxisCount: 3, // 3x3grid
              crossAxisSpacing: 2.0, 
              mainAxisSpacing: 2.0, 
              physics: const NeverScrollableScrollPhysics(), 
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
