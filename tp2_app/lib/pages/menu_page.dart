import 'package:flutter/material.dart';
import 'image_transform_page.dart';
import 'display_tile_page.dart';
import 'configurable_grid_page.dart';

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
            title: 'Exercise 2',
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
            title: 'Exercise 4a',
            subtitle: 'Display a Tile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DisplayTileWidget(),
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