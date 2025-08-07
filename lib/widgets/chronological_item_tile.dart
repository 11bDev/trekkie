import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';

class ChronologicalItemTile extends StatefulWidget {
  final ChronologicalItem item;
  final StarTrekService service;

  const ChronologicalItemTile({
    super.key,
    required this.item,
    required this.service,
  });

  @override
  State<ChronologicalItemTile> createState() => _ChronologicalItemTileState();
}

class _ChronologicalItemTileState extends State<ChronologicalItemTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          widget.item.title,
          style: TextStyle(
            decoration: widget.item.isWatched 
                ? TextDecoration.lineThrough 
                : null,
            color: widget.item.isWatched 
                ? Colors.grey 
                : null,
          ),
        ),
        subtitle: _buildSubtitle(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                widget.item.isFavorite ? Icons.star : Icons.star_border,
                color: widget.item.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () async {
                if (widget.item.type == 'episode') {
                  final episodeItem = widget.item as EpisodeChronologicalItem;
                  setState(() {
                    episodeItem.episode.isFavorite = !episodeItem.episode.isFavorite;
                  });
                  await widget.service.markEpisodeFavorite(
                    widget.item.id, 
                    episodeItem.episode.isFavorite,
                  );
                } else {
                  final movieItem = widget.item as MovieChronologicalItem;
                  setState(() {
                    movieItem.movie.isFavorite = !movieItem.movie.isFavorite;
                  });
                  await widget.service.markMovieFavorite(
                    widget.item.id, 
                    movieItem.movie.isFavorite,
                  );
                }
              },
            ),
            Checkbox(
              value: widget.item.isWatched,
              onChanged: (bool? value) async {
                if (widget.item.type == 'episode') {
                  final episodeItem = widget.item as EpisodeChronologicalItem;
                  setState(() {
                    episodeItem.episode.isWatched = value ?? false;
                    if (episodeItem.episode.isWatched) {
                      episodeItem.episode.watchedDate = DateTime.now();
                    } else {
                      episodeItem.episode.watchedDate = null;
                    }
                  });
                  await widget.service.markEpisodeWatched(
                    widget.item.id, 
                    episodeItem.episode.isWatched,
                  );
                } else {
                  final movieItem = widget.item as MovieChronologicalItem;
                  setState(() {
                    movieItem.movie.isWatched = value ?? false;
                    if (movieItem.movie.isWatched) {
                      movieItem.movie.watchedDate = DateTime.now();
                    } else {
                      movieItem.movie.watchedDate = null;
                    }
                  });
                  await widget.service.markMovieWatched(
                    widget.item.id, 
                    movieItem.movie.isWatched,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (widget.item.type == 'movie') {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.amber.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.movie,
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      final episodeItem = widget.item as EpisodeChronologicalItem;
      return CircleAvatar(
        backgroundColor: widget.item.isWatched 
            ? Colors.green 
            : Colors.grey.shade300,
        child: Text(
          'E${episodeItem.episode.episodeNumber}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: widget.item.isWatched ? Colors.white : Colors.black54,
          ),
        ),
      );
    }
  }

  Widget _buildSubtitle() {
    final children = <Widget>[];
    
    if (widget.item.type == 'episode') {
      final episodeItem = widget.item as EpisodeChronologicalItem;
      children.add(Text(
        episodeItem.subtitle,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ));
    } else {
      children.add(const Text(
        'Movie',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
      ));
    }
    
    if (widget.item.stardate != null) {
      children.add(Text(
        'Stardate: ${widget.item.stardate!.toStringAsFixed(1)}',
        style: const TextStyle(fontSize: 11, color: Colors.blue),
      ));
    } else if (widget.item.airDate != null) {
      children.add(Text(
        'Aired: ${DateFormat('MMM d, yyyy').format(widget.item.airDate!)}',
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ));
    }
    
    if (widget.item.watchedDate != null) {
      children.add(Text(
        'Watched: ${DateFormat('MMM d, yyyy').format(widget.item.watchedDate!)}',
        style: const TextStyle(fontSize: 11, color: Colors.green),
      ));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}