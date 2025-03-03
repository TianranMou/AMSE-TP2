//exo 6b
import 'package:flutter/material.dart';
import 'dart:math' as math;

// 定义 Tile 模型
class Tile {
  String id;
  Color color;
  int initialPosition;

  Tile(this.id, this.color, this.initialPosition);

  factory Tile.withRandomColor(int index) {
    return Tile(
      'Tile $index',
      Color.fromARGB(
        255,
        math.Random().nextInt(200) + 55,
        math.Random().nextInt(200) + 55,
        math.Random().nextInt(200) + 55,
      ),
      index,
    );
  }
}

class MovingTilesPage extends StatefulWidget {
  final int gridSize;

  const MovingTilesPage({
    Key? key,
    this.gridSize = 4,
  }) : super(key: key);

  @override
  State<MovingTilesPage> createState() => _MovingTilesPageState();
}

class _MovingTilesPageState extends State<MovingTilesPage> {
  late List<Tile?> tiles;
  int? emptyIndex;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _initTiles();
  }

  void _initTiles() {
    final size = widget.gridSize * widget.gridSize;
    tiles = List.generate(size, (index) {
      return Tile.withRandomColor(index);
    });
    emptyIndex = null;
    initialized = false;
  }

  bool _isAdjacent(int index) {
    if (emptyIndex == null) return false;

    int emptyRow = emptyIndex! ~/ widget.gridSize;
    int emptyCol = emptyIndex! % widget.gridSize;
    int row = index ~/ widget.gridSize;
    int col = index % widget.gridSize;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  void _selectEmptyTile(int index) {
    setState(() {
      emptyIndex = index;
      initialized = true;
    });
  }

  void _moveTile(int index) {
    if (!_isAdjacent(index) || emptyIndex == null) return;

    setState(() {
      // 交换位置
      final temp = tiles[index];
      tiles[index] = null;
      tiles[emptyIndex!] = temp;
      emptyIndex = index;
    });
  }

  void _resetBoard() {
    setState(() {
      _initTiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swapable Color Grid Widget'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridSize,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  bool isEmpty = index == emptyIndex;
                  bool isAdjacent = _isAdjacent(index);

                  if (isEmpty) {
                    return Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Empty',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  final tile = tiles[index]!;

                  return GestureDetector(
                    onTap: () {
                      if (!initialized) {
                        _selectEmptyTile(index);
                      } else if (isAdjacent) {
                        _moveTile(index);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: tile.color,
                        border: Border.all(
                          color: isAdjacent ? Colors.red : Colors.white,
                          width: isAdjacent ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tile.id,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetBoard,
        tooltip: 'Reset',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
