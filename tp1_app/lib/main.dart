// main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/media_screen.dart';
import 'screens/about_screen.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Media Manager',
     theme: ThemeData(primarySwatch: Colors.blue),
     builder: (context, child) {
       return MediaQuery(
         data: const MediaQueryData(
           size: Size(360, 640),
           devicePixelRatio: 2.0,
         ),
         child: child!,
       );
     },
     home: const MainScreen(),
   );
 }
}

class MainScreen extends StatefulWidget {
 const MainScreen({super.key});

 @override
 State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 int _selectedIndex = 0;

 static const List<Widget> _screens = [
   HomeScreen(),
   MediaScreen(),
   AboutScreen(),
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
       items: const [
         BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.library_books),
           label: 'Media',
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
