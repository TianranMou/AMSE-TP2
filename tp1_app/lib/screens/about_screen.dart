import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.info,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Media Manager',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'A simple media management application built with Flutter.\n'
              'Manage your favorite books, movies, TV series, and more!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}