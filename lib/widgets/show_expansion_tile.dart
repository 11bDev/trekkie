import 'package:flutter/material.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';
import 'season_expansion_tile.dart';
import 'captain_avatar.dart';

class ShowExpansionTile extends StatelessWidget {
  final StarTrekShow show;
  final StarTrekService service;

  const ShowExpansionTile({
    super.key,
    required this.show,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final allEpisodes = show.seasons.expand((s) => s.episodes).toList();
    final watchedCount = allEpisodes.where((e) => e.isWatched).length;
    final totalCount = allEpisodes.length;
    final favoriteCount = allEpisodes.where((e) => e.isFavorite).length;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: CaptainAvatar(
          showId: show.id,
          size: 70,
          fallbackText: show.abbreviation,
          fallbackColor: _getShowColor(show.abbreviation),
        ),
        title: Text(
          show.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${show.timelineStart.year} - ${show.timelineEnd.year}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '$watchedCount/$totalCount episodes',
                  style: const TextStyle(fontSize: 16),
                ),
                if (favoriteCount > 0) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.star, size: 18, color: Colors.amber),
                  Text(
                    ' $favoriteCount',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ],
        ),
        children: show.seasons.map((season) => 
          SeasonExpansionTile(
            season: season,
            service: service,
          ),
        ).toList(),
      ),
    );
  }

  Color _getShowColor(String abbreviation) {
    switch (abbreviation) {
      case 'TOS':
        return Colors.blue;
      case 'TNG':
        return Colors.red;
      case 'DS9':
        return Colors.purple;
      case 'VOY':
        return Colors.teal;
      case 'ENT':
        return Colors.orange;
      case 'DIS':
        return Colors.indigo;
      case 'PIC':
        return Colors.brown;
      case 'LD':
        return Colors.green;
      case 'PRO':
        return Colors.pink;
      case 'SNW':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}