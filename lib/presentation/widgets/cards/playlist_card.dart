import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  final int trackCount;
  final VoidCallback onTap;

  const PlaylistCard({super.key, required this.title, required this.trackCount, required this.onTap});

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
            color: const Color(0xFFE91E63).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.list, color: Color(0xFFE91E63), size: 24),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text('$trackCount tracks', style: const TextStyle(color: Color(0xFFB3B3B3))),
        onTap: onTap,
      ),
    );
  }
}
