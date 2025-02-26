import 'package:flutter/material.dart';

class ConfigurableGridPage extends StatefulWidget {
  const ConfigurableGridPage({super.key});

  @override
  State<ConfigurableGridPage> createState() => _ConfigurableGridPageState();
}

class _ConfigurableGridPageState extends State<ConfigurableGridPage> {
  double _gridSize = 3;
  final String imageUrl = 'https://picsum.photos/512';

  @override
  Widget build(BuildContext context) {
    int size = _gridSize.round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taquin Board'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double minSize = constraints.maxWidth < constraints.maxHeight 
                      ? constraints.maxWidth 
                      : constraints.maxHeight;
                  
                  final tileSize = (minSize - 40) / size; // 计算单个瓦片的大小
                  
                  return Container(
                    margin: const EdgeInsets.all(20.0),
                    width: minSize - 40,
                    height: minSize - 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  col / (size - 1),
                                  row / (size - 1),
                                ),
                                child: SizedBox(
                                  width: tileSize * size,
                                  height: tileSize * size,
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
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text('Size: '),
                Expanded(
                  child: Slider(
                    value: _gridSize,
                    min: 2,
                    max: 10,
                    divisions: 8,
                    label: '${_gridSize.round()}',
                    onChanged: (value) => setState(() => _gridSize = value),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_gridSize.round()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}