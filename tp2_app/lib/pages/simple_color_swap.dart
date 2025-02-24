import 'package:flutter/material.dart';
import 'dart:math' as math;

class Tile {
  Color color;

  Tile(this.color);

  // 创建随机颜色的 Tile
  Tile.randomColor() : color = Color.fromARGB(
    255,
    math.Random().nextInt(200) + 55,
    math.Random().nextInt(200) + 55,
    math.Random().nextInt(200) + 55,
  );
}

class TileWidget extends StatelessWidget {
  final Tile tile;

  const TileWidget({
    Key? key,
    required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tile.color,
      child: Padding(
        padding: const EdgeInsets.all(70.0),
      ),
    );
  }
}

class SimpleColorSwap extends StatefulWidget {
  const SimpleColorSwap({Key? key}) : super(key: key);

  @override
  State<SimpleColorSwap> createState() => _SimpleColorSwapState();
}

class _SimpleColorSwapState extends State<SimpleColorSwap> {
  late List<Widget> tiles;

  @override
  void initState() {
    super.initState();
    tiles = [
      TileWidget(tile: Tile.randomColor()),
      TileWidget(tile: Tile.randomColor()),
    ];
  }

  void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moving Tiles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: tiles,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: swapTiles,
        tooltip: 'Swap Tiles',
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }
}