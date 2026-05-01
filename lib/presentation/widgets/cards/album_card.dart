import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final VoidCallback onTap;

  const AlbumCard({super.key, required this.title, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.album, color: Color(0xFF9C27B0), size: 24),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(artist, style: const TextStyle(color: Color(0xFFB3B3B3))),
        onTap: onTap,
      ),
    );
  }
}
