import 'package:flutter/material.dart';

class ConfigurableGridPage extends StatefulWidget {
  const ConfigurableGridPage({super.key});

  @override
  State<ConfigurableGridPage> createState() => _ConfigurableGridPageState();
}

class _ConfigurableGridPageState extends State<ConfigurableGridPage> {
  double _gridSize = 3;
  final String imageUrl = 'https://m.media-amazon.com/images/I/51Y52SEf7tL._SX300_SY300_QL70_FMwebp_.jpg'; // 可以是任意尺寸的图片

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
                  
                  return Container(
                    margin: const EdgeInsets.all(20.0),
                    width: minSize - 40, // 减去边距
                    height: minSize - 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Error loading image'));
                          },
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size,
                          ),
                          itemCount: size * size,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 0.5),
                              ),
                            );
                          },
                        ),
                      ],
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