import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String genre;
  final VoidCallback onTap;

  const ArtistCard({super.key, required this.name, required this.genre, required this.onTap});

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
            color: const Color(0xFF4CAF50).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, color: Color(0xFF4CAF50), size: 24),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(genre, style: const TextStyle(color: Color(0xFFB3B3B3))),
        onTap: onTap,
      ),
    );
  }
}
