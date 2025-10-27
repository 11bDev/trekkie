import 'package:flutter/material.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';
import 'episode_tile.dart';

class SeasonExpansionTile extends StatelessWidget {
  final Season season;
  final StarTrekService service;
  final bool initiallyExpanded;

  const SeasonExpansionTile({
    super.key,
    required this.season,
    required this.service,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final watchedCount = season.episodes.where((e) => e.isWatched).length;
    final totalCount = season.episodes.length;
    final favoriteCount = season.episodes.where((e) => e.isFavorite).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: CircleAvatar(
          backgroundColor: watchedCount == totalCount
              ? Colors.green.shade600
              : watchedCount > 0
              ? Colors.orange.shade600
              : Colors.blue.shade600,
          child: Text(
            'S${season.number}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          'Season ${season.number}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Row(
          children: [
            Text(
              '$watchedCount/$totalCount watched',
              style: const TextStyle(fontSize: 16),
            ),
            if (favoriteCount > 0) ...[
              const SizedBox(width: 8),
              Icon(Icons.star, size: 18, color: Colors.amber),
              Text(' $favoriteCount', style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
        children: season.episodes
            .map((episode) => EpisodeTile(episode: episode, service: service))
            .toList(),
      ),
    );
  }
}
