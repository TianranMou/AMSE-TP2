import 'package:flutter/material.dart';
import 'image_transform_page.dart';
import 'display_tile_page.dart';
import 'configurable_grid_page.dart';
import 'moving_tiles_page.dart';
import 'simple_color_swap.dart';
import 'grid_view_example_page.dart';
import 'image_grid_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ExerciseCard(
            title: 'Exercise 2a',
            subtitle: 'Rotate&Scale image',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImageTransformPage(
                  title: 'Image Transform',
                  animated: false,
                ),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 2b',
            subtitle: 'Animated Rotate&Scale image',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImageTransformPage(
                  title: 'Animated Transform',
                  animated: true,
                ),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 4',
            subtitle: 'Display a Tile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DisplayTileWidget(),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 5a',  
            subtitle: 'Grid of Colored Boxes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GridViewExamplePage(),
              ),
            ),
          ),
           ExerciseCard(
            title: 'Exercise 5b',  
            subtitle: 'Fixed Image Grid',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImageGridPage(),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 5c',
            subtitle: 'Configurable Taquin Board',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfigurableGridPage(),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 6a',
            subtitle: 'Simple Color Swap',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimpleColorSwap(),
              ),
            ),
          ),
          ExerciseCard(
            title: 'Exercise 6b',
            subtitle: 'Moving Tiles in Grid',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MovingTilesPage(gridSize: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}