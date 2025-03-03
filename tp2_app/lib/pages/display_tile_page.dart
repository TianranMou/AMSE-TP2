//exo 4
import 'package:flutter/material.dart';

class Tile {
  final String imageURL;
  final Alignment alignment;

  Tile({required this.imageURL, required this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Image.network(imageURL),
        ),
      ),
    );
  }
}

class DisplayTileWidget extends StatelessWidget {
  const DisplayTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Tile tile = Tile(
      imageURL: 'https://picsum.photos/512',
      alignment: const Alignment(0, 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Display a Tile as a Cropped Image'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: createTileWidgetFrom(tile),
              ),
            ),
            Container(
              height: 200,
              child: Image.network(
                'https://picsum.photos/512',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
