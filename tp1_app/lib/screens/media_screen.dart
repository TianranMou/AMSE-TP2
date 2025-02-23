import 'package:flutter/material.dart';
import '../models/media_item.dart';

class MediaScreen extends StatefulWidget {
 final Map<String, MediaItem> likedItemsMap;
 final Function(MediaItem, bool) onLikeToggle;
 
 const MediaScreen({
   Key? key, 
   required this.likedItemsMap,
   required this.onLikeToggle,
 }) : super(key: key);

 @override
 State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
 final TextEditingController _searchController = TextEditingController();
 String _searchQuery = '';

 final List<MediaItem> _items = [
   MediaItem(
     id: '1',
     title: 'The Lord of the Rings',
     type: 'Book',
     description: 'Epic fantasy novel by J.R.R. Tolkien',
     imageUrl: 'https://m.media-amazon.com/images/I/71jLBXtWJWL._AC_UF1000,1000_QL80_.jpg',
   ),
   MediaItem(
     id: '2',
     title: 'Breaking Bad',
     type: 'TV Series', 
     description: 'Crime drama television series',
     imageUrl: 'https://m.media-amazon.com/images/M/MV5BYmQ4YWMxYjUtNjZmYi00MDQ1LWFjMjMtNjA5ZDdiYjdiODU5XkEyXkFqcGdeQXVyMTMzNDExODE5._V1_.jpg',
   ),
   MediaItem(
     id: '3',
     title: 'The Legend of Zelda',
     type: 'Game',
     description: 'Action-adventure game series',
     imageUrl: 'https://fs-prod-cdn.nintendo-europe.com/media/images/10_share_images/games_15/nintendo_switch_4/2x1_NSwitch_TloZTearsOfTheKingdom_Gamepage.jpg',
   ),
   MediaItem(
     id: '4',
     title: 'Final Fantasy X',
     type: 'Game',
     description: 'Role-playing video game developed by Square',
     imageUrl: 'https://upload.wikimedia.org/wikipedia/en/a/a7/Final_Fantasy_X.jpg',
   ),
   MediaItem(
     id: '5',
     title: 'Avengers: Endgame',
     type: 'Movie',
     description: 'Superhero film produced by Marvel Studios',
     imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
   ),
   MediaItem(
     id: '6',
     title: 'Harry Potter',
     type: 'Book',
     description: 'Fantasy novel series written by J.K. Rowling',
     imageUrl: 'https://m.media-amazon.com/images/I/71-++HbSa0L._AC_UF1000,1000_QL80_.jpg',
   ),
   MediaItem(
     id: '7',
     title: 'Stranger Things',
     type: 'TV Series',
     description: 'Science fiction horror drama television series',
     imageUrl: 'https://m.media-amazon.com/images/M/MV5BMDZkYmVhNjMtNWU4MC00MDQxLWE3MjYtZGMzZWI1ZjhlOWJmXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg',
   ),
   MediaItem(
     id: '8',
     title: 'The Witcher 3',
     type: 'Game',
     description: 'Action role-playing game developed by CD Projekt Red',
     imageUrl: 'https://image.api.playstation.com/vulcan/img/rnd/202211/0711/Fki2Ul4MQLhHECZAcNwEdN5F.jpg',
   ),
   MediaItem(
     id: '9',
     title: 'Inception',
     type: 'Movie',
     description: 'Science fiction action film written and directed by Christopher Nolan',
     imageUrl: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg',
   ),
 ];

 @override
 void dispose() {
   _searchController.dispose();
   super.dispose();
 }

 List<MediaItem> _getFilteredItems(List<MediaItem> items) {
   if (_searchQuery.isEmpty) return items;
   return items.where((item) => 
     item.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
     item.type.toLowerCase().contains(_searchQuery.toLowerCase())
   ).toList();
 }

 @override
 Widget build(BuildContext context) {
   for (var item in _items) {
     item.isLiked = widget.likedItemsMap.containsKey(item.id);
   }

   return DefaultTabController(
     length: 4,
     child: Scaffold(
       appBar: AppBar(
         title: const Text('Media Library'),
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
       body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               controller: _searchController,
               decoration: InputDecoration(
                 labelText: 'Search',
                 hintText: 'Search title or type...',
                 prefixIcon: const Icon(Icons.search),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 suffixIcon: _searchQuery.isNotEmpty 
                   ? IconButton(
                       icon: const Icon(Icons.clear),
                       onPressed: () {
                         _searchController.clear();
                         setState(() {
                           _searchQuery = '';
                         });
                       },
                     )
                   : null,
               ),
               onChanged: (value) {
                 setState(() {
                   _searchQuery = value;
                 });
               },
             ),
           ),
           Expanded(
             child: TabBarView(
               children: [
                 _buildMediaList(_getFilteredItems(_items)),
                 _buildMediaList(_getFilteredItems(_items.where((item) => item.type == 'Book').toList())),
                 _buildMediaList(_getFilteredItems(_items.where((item) => item.type == 'TV Series').toList())),
                 _buildMediaList(_getFilteredItems(_items.where((item) => item.type == 'Game').toList())),
               ],
             ),
           ),
         ],
       ),
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
             icon: Icon(
               item.isLiked ? Icons.favorite : Icons.favorite_border,
               color: item.isLiked ? Colors.red : null,
             ),
             onPressed: () {
               setState(() {
                 item.isLiked = !item.isLiked;
               });
               widget.onLikeToggle(item, item.isLiked);
             },
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