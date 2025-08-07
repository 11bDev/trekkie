import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';

class EpisodeTile extends StatefulWidget {
  final Episode episode;
  final StarTrekService service;

  const EpisodeTile({
    super.key,
    required this.episode,
    required this.service,
  });

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.episode.isWatched 
              ? Colors.green.shade600
              : Colors.blue.shade600,
          child: Text(
            'E${widget.episode.episodeNumber}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          widget.episode.title,
          style: TextStyle(
            fontSize: 17,
            decoration: widget.episode.isWatched 
                ? TextDecoration.lineThrough 
                : null,
            color: widget.episode.isWatched 
                ? Colors.grey 
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.episode.stardate != null)
              Text(
                'Stardate: ${widget.episode.stardate!.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 13, color: Colors.blue),
              ),
            if (widget.episode.watchedDate != null)
              Text(
                'Watched: ${DateFormat('MMM d, yyyy').format(widget.episode.watchedDate!)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                widget.episode.isFavorite ? Icons.star : Icons.star_border,
                color: widget.episode.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () async {
                setState(() {
                  widget.episode.isFavorite = !widget.episode.isFavorite;
                });
                await widget.service.markEpisodeFavorite(
                  widget.episode.id, 
                  widget.episode.isFavorite,
                );
              },
            ),
            Checkbox(
              value: widget.episode.isWatched,
              onChanged: (bool? value) async {
                setState(() {
                  widget.episode.isWatched = value ?? false;
                  if (widget.episode.isWatched) {
                    widget.episode.watchedDate = DateTime.now();
                  } else {
                    widget.episode.watchedDate = null;
                  }
                });
                await widget.service.markEpisodeWatched(
                  widget.episode.id, 
                  widget.episode.isWatched,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}