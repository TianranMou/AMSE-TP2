import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.home,
            size: 80,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Media Manager',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Manage your favorite books, movies, and more!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}