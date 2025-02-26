import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

// Import image picker plugin if you want to implement the optional photo selection feature
// import 'package:image_picker/image_picker.dart';

enum GameState { initial, playing, won }

class TaquinGame extends StatefulWidget {
  const TaquinGame({Key? key}) : super(key: key);

  @override
  State<TaquinGame> createState() => _TaquinGameState();
}

class _TaquinGameState extends State<TaquinGame> {
  int _gridSize = 4; // Default 4x4 grid
  int _moves = 0;
  int _shuffleMoves = 20; // Default shuffle moves
  GameState _gameState = GameState.initial;
  List<int> _tiles = [];
  final List<List<int>> _moveHistory = []; // Move history for undo
  int? _selectedTileIndex; // Track the first selected tile for swapping
  
  String _imageUrl = 'https://picsum.photos/512'; // Default image URL
  
  bool get isPlaying => _gameState == GameState.playing;
  bool get hasWon => _gameState == GameState.won;
  
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }
  
  void _initializeGame() {
    // Initialize tiles in order (0, 1, 2, ..., n²-1)
    _tiles = List.generate(_gridSize * _gridSize, (index) => index);
    _gameState = GameState.initial;
    _moves = 0;
    _moveHistory.clear();
    _selectedTileIndex = null;
  }
  
  // Check if the player has won
  bool _checkWin() {
    for (int i = 0; i < _tiles.length; i++) {
      if (_tiles[i] != i) {
        return false;
      }
    }
    return true;
  }
  
  // Check if two tiles are adjacent
  bool _areAdjacent(int firstIndex, int secondIndex) {
    int firstRow = firstIndex ~/ _gridSize;
    int firstCol = firstIndex % _gridSize;
    int secondRow = secondIndex ~/ _gridSize;
    int secondCol = secondIndex % _gridSize;
    
    // Adjacent if they are in the same row and columns differ by 1,
    // or in the same column and rows differ by 1
    return (firstRow == secondRow && (firstCol - secondCol).abs() == 1) ||
           (firstCol == secondCol && (firstRow - secondRow).abs() == 1);
  }
  
  // Swap two tiles
  void _swapTiles(int firstIndex, int secondIndex) {
    if (_gameState == GameState.won) return;
    
    // Check if tiles are adjacent
    if (!_areAdjacent(firstIndex, secondIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only adjacent tiles can be swapped!'),
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {
        _selectedTileIndex = null; // Reset selection
      });
      return;
    }
    
    setState(() {
      if (_gameState == GameState.initial) {
        _gameState = GameState.playing;
      }
      
      // Record the move for undo
      _moveHistory.add([firstIndex, secondIndex]);
      
      // Swap the tiles
      final temp = _tiles[firstIndex];
      _tiles[firstIndex] = _tiles[secondIndex];
      _tiles[secondIndex] = temp;
      
      // Increment move counter
      _moves++;
      
      // Check if the player has won
      if (_checkWin()) {
        _gameState = GameState.won;
      }
    });
  }
  
  // Handle tile tap
  // Handle tile tap
  void _handleTileTap(int index) {
    if (_gameState == GameState.won) return;
    
    if (_selectedTileIndex == null) {
      // First tile selected
      setState(() {
        _selectedTileIndex = index;
      });
    } else if (_selectedTileIndex != index) {
      // Second tile selected, swap them
      _swapTiles(_selectedTileIndex!, index);
      setState(() {
        _selectedTileIndex = null; // Reset selection
      });
    }
  }
  
  // Undo the last move
  void _undoLastMove() {
    if (_moveHistory.isEmpty) return;
    
    setState(() {
      // Get the last move
      final lastMove = _moveHistory.removeLast();
      final firstIndex = lastMove[0];
      final secondIndex = lastMove[1];
      
      // Swap the tiles back
      final temp = _tiles[firstIndex];
      _tiles[firstIndex] = _tiles[secondIndex];
      _tiles[secondIndex] = temp;
      
      // Decrement move counter
      _moves--;
      
      // If we're back to the initial state
      if (_moveHistory.isEmpty && _moves == 0) {
        _gameState = GameState.initial;
      }
      
      // Clear any selection
      _selectedTileIndex = null;
    });
  }
  
  // Shuffle the tiles
  void _shuffleTiles() {
    _initializeGame();
    
    final random = math.Random();
    
    // Perform random valid swaps
    for (int i = 0; i < _shuffleMoves; i++) {
      final firstIndex = random.nextInt(_tiles.length);
      int secondIndex;
      
      do {
        secondIndex = random.nextInt(_tiles.length);
      } while (secondIndex == firstIndex);
      
      // Swap the tiles
      final temp = _tiles[firstIndex];
      _tiles[firstIndex] = _tiles[secondIndex];
      _tiles[secondIndex] = temp;
    }
    
    // Reset game state
    setState(() {
      _gameState = GameState.playing;
      _moves = 0;
      _moveHistory.clear();
      _selectedTileIndex = null;
    });
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
  
  // Change the image URL
  void _changeImageUrl(String url) {
    setState(() {
      _imageUrl = url;
    });
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
                  // Get the tile value
                  final tileIndex = _tiles[index];
                  final isSelected = index == _selectedTileIndex;
                  
                  return GestureDetector(
                    onTap: () => _handleTileTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.white, 
                          width: isSelected ? 3 : 1
                        ),
                      ),
                      child: TaquinTile(
                        imageUrl: _imageUrl,
                        gridSize: _gridSize,
                        tileIndex: tileIndex,
                        originalIndex: index,
                        tileSize: tileSize,
                        isSelected: isSelected,
                        hasWon: hasWon,
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
              Text('Grid Size: $_gridSize x $_gridSize', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _gridSize > 2 ? () => _changeGridSize(_gridSize - 1) : null,
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
                onPressed: _gridSize < 6 ? () => _changeGridSize(_gridSize + 1) : null,
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

  // Load a random image from picsum.photos
  void _loadRandomImage() {
    setState(() {
      // Add a random parameter to force reload a new image
      _imageUrl = 'https://picsum.photos/512?random=${DateTime.now().millisecondsSinceEpoch}';
    });
    
    // Show a snackbar to notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New random image loaded!'),
        duration: Duration(seconds: 1),
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

  const TaquinTile({
    Key? key,
    required this.imageUrl,
    required this.gridSize,
    required this.tileIndex,
    required this.originalIndex,
    required this.tileSize,
    required this.isSelected,
    required this.hasWon,
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
    
    return ClipRect(
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
    );
  }
}