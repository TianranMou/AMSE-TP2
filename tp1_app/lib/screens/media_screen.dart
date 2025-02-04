import 'package:flutter/material.dart';
import '../models/media_item.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final List<MediaItem> _items = [
    MediaItem(
      id: '1',
      title: 'The Lord of the Rings',
      type: 'Book',
      description: 'Epic fantasy novel by J.R.R. Tolkien',
    ),
    MediaItem(
      id: '2',
      title: 'Breaking Bad',
      type: 'TV Series',
      description: 'Crime drama television series',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Books'),
              Tab(text: 'TV Series'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMediaList(_items),
                _buildMediaList(_items.where((item) => item.type == 'Book').toList()),
                _buildMediaList(_items.where((item) => item.type == 'TV Series').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaList(List<MediaItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(item.title),
            subtitle: Text(item.type),
            trailing: IconButton(
              icon: Icon(
                item.isLiked ? Icons.favorite : Icons.favorite_border,
                color: item.isLiked ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  item.isLiked = !item.isLiked;
                });
              },
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(item.title),
                  content: Text(item.description),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}