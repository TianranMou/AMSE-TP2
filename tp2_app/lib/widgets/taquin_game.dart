import 'package:flutter/material.dart';
import 'dart:math' as math;
//import 'dart:async';

enum GameState { initial, playing, won }

class TaquinGame extends StatefulWidget {
  const TaquinGame({super.key});

  @override
  State<TaquinGame> createState() => _TaquinGameState();
}

class _TaquinGameState extends State<TaquinGame> {
  int _gridSize = 4; // Default 4x4 grid
  int _moves = 0;
  int _shuffleMoves = 20; // Default shuffle moves
  GameState _gameState = GameState.initial;
  List<int?> _tiles = []; // Nullable int list to represent empty tile
  int _emptyTileIndex =
      15; // Default position of empty tile (bottom-right corner)
  final List<List<int>> _moveHistory = []; // Move history for undo
  bool _showNumbers = true; // Flag to control number visibility
  int _estimatedRemainingMoves = 0; // Store estimate of remaining moves

  String _imageUrl = 'https://picsum.photos/512'; // Default image URL

  bool get isPlaying => _gameState == GameState.playing;
  bool get hasWon => _gameState == GameState.won;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize tiles in order (0, 1, 2, ..., n²-2, null)
    // The empty tile (null) is at the last position
    _tiles = List.generate(_gridSize * _gridSize,
        (index) => index == _gridSize * _gridSize - 1 ? null : index);
    _emptyTileIndex = _gridSize * _gridSize - 1;
    _gameState = GameState.initial;
    _moves = 0;
    _moveHistory.clear();
    _estimatedRemainingMoves = 0; // Initially solved, so 0 steps remaining
  }

  // Check if the player has won
  bool _checkWin() {
    for (int i = 0; i < _tiles.length - 1; i++) {
      if (_tiles[i] != i) {
        return false;
      }
    }
    return _tiles.last == null; // Last position should be empty
  }

  // Check if a tile is adjacent to the empty tile
  bool _isAdjacentToEmpty(int tileIndex) {
    int tileRow = tileIndex ~/ _gridSize;
    int tileCol = tileIndex % _gridSize;
    int emptyRow = _emptyTileIndex ~/ _gridSize;
    int emptyCol = _emptyTileIndex % _gridSize;

    return (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
        (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);
  }

  // Move a tile to the empty position
  void _moveTile(int tileIndex) {
    if (_gameState == GameState.won) return;

    // Check if the tile is adjacent to the empty tile
    if (!_isAdjacentToEmpty(tileIndex)) {
      return;
    }

    setState(() {
      if (_gameState == GameState.initial) {
        _gameState = GameState.playing;
      }

      // Record the move for undo
      _moveHistory.add([tileIndex, _emptyTileIndex]);

      // Move the tile to the empty position
      _tiles[_emptyTileIndex] = _tiles[tileIndex];
      _tiles[tileIndex] = null;
      _emptyTileIndex = tileIndex;

      // Increment move counter
      _moves++;

      // Update estimated remaining moves
      _updateEstimatedRemainingMoves();

      // Check if the player has won
      if (_checkWin()) {
        _gameState = GameState.won;
      }
    });
  }

  // Handle tile tap
  void _handleTileTap(int index) {
    if (_gameState == GameState.won) return;

    // Only allow tapping tiles adjacent to the empty tile
    if (_tiles[index] != null && _isAdjacentToEmpty(index)) {
      _moveTile(index);
    }
  }

  // Undo the last move
  void _undoLastMove() {
    if (_moveHistory.isEmpty) return;

    setState(() {
      // Get the last move
      final lastMove = _moveHistory.removeLast();
      final tileIndex = lastMove[0];
      final previousEmptyIndex = lastMove[1];

      // Move the tile back
      _tiles[tileIndex] = _tiles[_emptyTileIndex];
      _tiles[_emptyTileIndex] = null;
      _emptyTileIndex = previousEmptyIndex;

      // Decrement move counter
      _moves--;

      // Update estimated remaining moves
      _updateEstimatedRemainingMoves();

      // If we're back to the initial state
      if (_moveHistory.isEmpty && _moves == 0) {
        _gameState = GameState.initial;
      }
    });
  }

  // Calculate and update estimated remaining moves
  void _updateEstimatedRemainingMoves() {
    int manhattanDistance = _calculateManhattanDistance(_tiles);
    int linearConflicts = _calculateLinearConflicts(_tiles);

    // Each linear conflict requires at least 2 extra moves
    _estimatedRemainingMoves = manhattanDistance + (linearConflicts * 2);
  }

  // Calculate Manhattan distance for all tiles
  int _calculateManhattanDistance(List<int?> state) {
    int distance = 0;
    for (int i = 0; i < state.length; i++) {
      if (state[i] != null) {
        int correctRow = state[i]! ~/ _gridSize;
        int correctCol = state[i]! % _gridSize;
        int currentRow = i ~/ _gridSize;
        int currentCol = i % _gridSize;
        distance +=
            (correctRow - currentRow).abs() + (correctCol - currentCol).abs();
      }
    }
    return distance;
  }

  // Calculate linear conflicts
  int _calculateLinearConflicts(List<int?> state) {
    int conflicts = 0;

    // Check row conflicts
    for (int row = 0; row < _gridSize; row++) {
      for (int col = 0; col < _gridSize - 1; col++) {
        int pos1 = row * _gridSize + col;

        if (state[pos1] == null) continue;

        // Check if this tile belongs to the current row
        int targetRow1 = state[pos1]! ~/ _gridSize;
        if (targetRow1 != row) continue;

        for (int col2 = col + 1; col2 < _gridSize; col2++) {
          int pos2 = row * _gridSize + col2;

          if (state[pos2] == null) continue;

          // Check if the other tile also belongs to the current row
          int targetRow2 = state[pos2]! ~/ _gridSize;
          if (targetRow2 != row) continue;

          // Check for conflict (tile to the right should have a higher target position)
          if (state[pos1]! > state[pos2]!) {
            conflicts++;
          }
        }
      }
    }

    // Check column conflicts
    for (int col = 0; col < _gridSize; col++) {
      for (int row = 0; row < _gridSize - 1; row++) {
        int pos1 = row * _gridSize + col;

        if (state[pos1] == null) continue;

        // Check if this tile belongs to the current column
        int targetCol1 = state[pos1]! % _gridSize;
        if (targetCol1 != col) continue;

        for (int row2 = row + 1; row2 < _gridSize; row2++) {
          int pos2 = row2 * _gridSize + col;

          if (state[pos2] == null) continue;

          // Check if the other tile also belongs to the current column
          int targetCol2 = state[pos2]! % _gridSize;
          if (targetCol2 != col) continue;

          // Check for conflict (tile below should have a higher target position)
          if (state[pos1]! > state[pos2]!) {
            conflicts++;
          }
        }
      }
    }

    return conflicts;
  }

  // Check if puzzle is solvable
  bool _isSolvable(List<int?> tiles) {
    // Create a list without the null value for inversion counting
    List<int> nonNullTiles = [];
    int emptyRowFromBottom = 0;

    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != null) {
        nonNullTiles.add(tiles[i]!);
      } else {
        // Calculate empty tile row from bottom
        emptyRowFromBottom = _gridSize - 1 - (i ~/ _gridSize);
      }
    }

    // Count inversions
    int inversions = 0;
    for (int i = 0; i < nonNullTiles.length; i++) {
      for (int j = i + 1; j < nonNullTiles.length; j++) {
        if (nonNullTiles[i] > nonNullTiles[j]) {
          inversions++;
        }
      }
    }

    // For odd grid sizes, the puzzle is solvable if inversions is even
    if (_gridSize % 2 == 1) {
      return inversions % 2 == 0;
    }
    // For even grid sizes, the puzzle is solvable if
    // (inversions + empty tile row from bottom) is even
    else {
      return (inversions + emptyRowFromBottom) % 2 == 0;
    }
  }

  // Shuffle the tiles
  void _shuffleTiles() {
    List<int?> shuffledTiles;
    final random = math.Random();
    bool isSolvable = false;

    // Keep shuffling until we get a solvable puzzle
    while (!isSolvable) {
      // Start with ordered tiles
      shuffledTiles = List.generate(_gridSize * _gridSize,
          (index) => index == _gridSize * _gridSize - 1 ? null : index);

      // Perform random swaps (only swap non-empty tiles)
      for (int i = 0; i < _shuffleMoves; i++) {
        // Get two random distinct indices, excluding the empty tile index
        List<int> validIndices = List.generate(shuffledTiles.length, (i) => i)
            .where((i) => shuffledTiles[i] != null)
            .toList();

        if (validIndices.length < 2) continue;

        int idx1 = validIndices[random.nextInt(validIndices.length)];
        int idx2;
        do {
          idx2 = validIndices[random.nextInt(validIndices.length)];
        } while (idx1 == idx2);

        // Swap the tiles
        int? temp = shuffledTiles[idx1];
        shuffledTiles[idx1] = shuffledTiles[idx2];
        shuffledTiles[idx2] = temp;
      }

      // Find the new empty tile position
      int emptyIndex = shuffledTiles.indexOf(null);

      // Check if the puzzle is solvable
      isSolvable = _isSolvable(shuffledTiles);

      if (isSolvable) {
        setState(() {
          _tiles = shuffledTiles;
          _emptyTileIndex = emptyIndex;
          _gameState = GameState.playing;
          _moves = 0;
          _moveHistory.clear();

          // Update estimated remaining moves for the new puzzle
          _updateEstimatedRemainingMoves();
        });
      }
    }
  }

  // Change the grid size
  void _changeGridSize(int size) {
    if (size != _gridSize) {
      setState(() {
        _gridSize = size;
        _initializeGame();
      });
    }
  }

  // Change difficulty (shuffle moves)
  void _changeDifficulty(int moves) {
    setState(() {
      _shuffleMoves = moves;
    });
  }

  // Toggle number visibility
  void _toggleNumberVisibility() {
    setState(() {
      _showNumbers = !_showNumbers;
    });
  }

  // Load a random image from picsum.photos
  void _loadRandomImage() {
    setState(() {
      // Add a random parameter to force reload a new image
      _imageUrl =
          'https://picsum.photos/512?random=${DateTime.now().millisecondsSinceEpoch}';
    });

    // Show a snackbar to notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New random image loaded!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Board'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Toggle number visibility button
          IconButton(
            icon: Icon(_showNumbers ? Icons.visibility_off : Icons.visibility),
            tooltip: _showNumbers ? '隐藏数字' : '显示数字',
            onPressed: _toggleNumberVisibility,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: _buildGameBoard(),
                ),
              ),
            ),
          ),
          if (hasWon)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Congratulations, you win!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the size of each tile based on available space
        final tileSize = constraints.maxWidth / _gridSize;

        return Stack(
          children: [
            // First place the full image as background (for win state)
            if (hasWon)
              Image.network(
                _imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),

            // Then build the tile grid on top
            if (!hasWon)
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: _gridSize * _gridSize,
                itemBuilder: (context, index) {
                  // Check if this is the empty tile
                  final isEmpty = _tiles[index] == null;
                  // Highlight tiles that can be moved (adjacent to empty)
                  final canMove = !isEmpty && _isAdjacentToEmpty(index);

                  return GestureDetector(
                    onTap: () => _handleTileTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: canMove ? Colors.blue : Colors.white,
                            width: canMove ? 3 : 1),
                        color: isEmpty ? Colors.grey.shade200 : null,
                      ),
                      child: isEmpty
                          ? const Center(
                              child: Text("Empty",
                                  style: TextStyle(color: Colors.grey)))
                          : TaquinTile(
                              imageUrl: _imageUrl,
                              gridSize: _gridSize,
                              tileIndex: _tiles[index]!,
                              originalIndex: index,
                              tileSize: tileSize,
                              isSelected: canMove,
                              hasWon: hasWon,
                              showNumber: _showNumbers,
                            ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Moves: $_moves', style: const TextStyle(fontSize: 16)),
              Text('Grid Size: $_gridSize x $_gridSize',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          if (isPlaying) // Only show estimated remaining moves during gameplay
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_walk,
                      size: 18, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    'Estimated steps to solve: $_estimatedRemainingMoves',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed:
                    _gridSize > 2 ? () => _changeGridSize(_gridSize - 1) : null,
              ),
              Expanded(
                child: Slider(
                  value: _gridSize.toDouble(),
                  min: 2,
                  max: 6,
                  divisions: 4,
                  label: '$_gridSize',
                  onChanged: (value) => _changeGridSize(value.toInt()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed:
                    _gridSize < 6 ? () => _changeGridSize(_gridSize + 1) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: _shuffleTiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Start', style: TextStyle(fontSize: 16)),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.undo),
                label: const Text('Undo'),
                onPressed: _moveHistory.isNotEmpty ? _undoLastMove : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Change Image'),
                onPressed: _loadRandomImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Difficulty: '),
              DropdownButton<int>(
                value: _shuffleMoves,
                items: const [
                  DropdownMenuItem(value: 10, child: Text('Easy')),
                  DropdownMenuItem(value: 20, child: Text('Medium')),
                  DropdownMenuItem(value: 50, child: Text('Hard')),
                  DropdownMenuItem(value: 100, child: Text('Expert')),
                ],
                onChanged: (value) {
                  if (value != null) _changeDifficulty(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaquinTile extends StatelessWidget {
  final String imageUrl;
  final int gridSize;
  final int tileIndex;
  final int originalIndex;
  final double tileSize;
  final bool isSelected;
  final bool hasWon;
  final bool showNumber;

  const TaquinTile({
    Key? key,
    required this.imageUrl,
    required this.gridSize,
    required this.tileIndex,
    required this.originalIndex,
    required this.tileSize,
    required this.isSelected,
    required this.hasWon,
    required this.showNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If game is won, don't show tiles
    if (hasWon) {
      return Container(color: Colors.transparent);
    }

    // Calculate the original position of this tile in the grid
    final int sourceRow = tileIndex ~/ gridSize;
    final int sourceCol = tileIndex % gridSize;

    return Stack(
      children: [
        // Image part of the tile
        ClipRect(
          child: SizedBox(
            width: tileSize,
            height: tileSize,
            child: FittedBox(
              fit: BoxFit.none,
              clipBehavior: Clip.hardEdge,
              alignment: FractionalOffset(
                sourceCol / (gridSize - 1),
                sourceRow / (gridSize - 1),
              ),
              child: SizedBox(
                width: tileSize * gridSize,
                height: tileSize * gridSize,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
          ),
        ),

        // Tile number overlay with enhanced styling
        if (showNumber)
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${tileIndex}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      gridSize <= 3 ? 30 : 24, // Larger font for smaller grids
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(2.0, 2.0),
                    ),
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.purple.withOpacity(0.7),
                      offset: const Offset(-1.0, -1.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
