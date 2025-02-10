// favorites_screen.dart
import 'package:flutter/material.dart';
import '../models/media_item.dart';

class FavoritesScreen extends StatelessWidget {
 final List<MediaItem> likedItems;
 final Function(MediaItem) onUnlike;
 
 const FavoritesScreen({
   Key? key, 
   required this.likedItems,
   required this.onUnlike,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return DefaultTabController(
     length: 4,
     child: Scaffold(
       appBar: AppBar(
         title: const Text('My Favorites'),
         bottom: const TabBar(
           labelColor: Colors.blue,
           tabs: [
             Tab(text: 'All'),
             Tab(text: 'Books'),
             Tab(text: 'TV Series'),
             Tab(text: 'Games'),
           ],
         ),
       ),
       body: TabBarView(
         children: [
           _buildList(likedItems),
           _buildList(likedItems.where((item) => item.type == 'Book').toList()),
           _buildList(likedItems.where((item) => item.type == 'TV Series').toList()),
           _buildList(likedItems.where((item) => item.type == 'Game').toList()),
         ],
       ),
     ),
   );
 }

 Widget _buildList(List<MediaItem> items) {
   return items.isEmpty
       ? const Center(child: Text('No favorites yet!'))
       : ListView.builder(
           itemCount: items.length,
           itemBuilder: (context, index) {
             final item = items[index];
             return Card(
               margin: const EdgeInsets.all(8.0),
               child: ListTile(
                 leading: ClipRRect(
                   borderRadius: BorderRadius.circular(4),
                   child: Image.network(
                     item.imageUrl,
                     width: 50,
                     height: 50,
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) {
                       return const Icon(Icons.image_not_supported, size: 50);
                     },
                   ),
                 ),
                 title: Text(item.title),
                 subtitle: Text(item.type),
                 trailing: IconButton(
                   icon: const Icon(Icons.favorite, color: Colors.red),
                   onPressed: () => onUnlike(item),
                 ),
                 onTap: () {
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: Text(item.title),
                       content: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Image.network(
                             item.imageUrl,
                             height: 200,
                             fit: BoxFit.cover,
                             errorBuilder: (context, error, stackTrace) {
                               return const Icon(Icons.image_not_supported, size: 200);
                             },
                           ),
                           const SizedBox(height: 16),
                           Text(item.description),
                         ],
                       ),
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