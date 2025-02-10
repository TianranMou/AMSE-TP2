// main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/media_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/about_screen.dart';
import 'models/media_item.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Media Manager',
     theme: ThemeData(
       primarySwatch: Colors.blue,
       visualDensity: VisualDensity.adaptivePlatformDensity,
     ),
     home: const MainScreen(),
   );
 }
}

class MainScreen extends StatefulWidget {
 const MainScreen({Key? key}) : super(key: key);

 @override
 _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 int _selectedIndex = 0;
 final Map<String, MediaItem> _likedItemsMap = {};

 void toggleLike(MediaItem item, bool isLiked) {
   setState(() {
     if (isLiked) {
       _likedItemsMap[item.id] = item;
     } else {
       _likedItemsMap.remove(item.id);
     }
   });
 }

 List<Widget> get _screens => [
   const HomeScreen(),
   MediaScreen(
     likedItemsMap: _likedItemsMap,
     onLikeToggle: toggleLike,
   ),
   FavoritesScreen(
     likedItems: _likedItemsMap.values.toList(),
     onUnlike: (item) => toggleLike(item, false),
   ),
   const AboutScreen(),
 ];

 void _onItemTapped(int index) {
   setState(() {
     _selectedIndex = index;
   });
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: _screens[_selectedIndex],
     bottomNavigationBar: BottomNavigationBar(
       type: BottomNavigationBarType.fixed,
       items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.library_books),
           label: 'Media',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.favorite),
           label: 'Favorites',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.info),
           label: 'About',
         ),
       ],
       currentIndex: _selectedIndex,
       onTap: _onItemTapped,
     ),
   );
 }
}