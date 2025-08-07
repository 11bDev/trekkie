import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';
import 'captain_avatar.dart';

class MovieTile extends StatefulWidget {
  final Movie movie;
  final StarTrekService service;

  const MovieTile({
    super.key,
    required this.movie,
    required this.service,
  });

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Stack(
          children: [
            CaptainAvatar(
              showId: widget.movie.id,
              size: 60,
              fallbackColor: Colors.amber.shade700,
              fallbackText: 'M',
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Icon(
                  Icons.movie,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          widget.movie.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: widget.movie.isWatched 
                ? TextDecoration.lineThrough 
                : null,
            color: widget.movie.isWatched 
                ? Colors.grey 
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.movie.stardate != null)
              Text(
                'Stardate: ${widget.movie.stardate!.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 14),
              ),
            if (widget.movie.releaseDate != null)
              Text(
                'Released: ${DateFormat('MMM d, yyyy').format(widget.movie.releaseDate!)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (widget.movie.watchedDate != null)
              Text(
                'Watched: ${DateFormat('MMM d, yyyy').format(widget.movie.watchedDate!)}',
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
            if (widget.movie.description != null)
              Text(
                widget.movie.description!,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                widget.movie.isFavorite ? Icons.star : Icons.star_border,
                color: widget.movie.isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: () async {
                setState(() {
                  widget.movie.isFavorite = !widget.movie.isFavorite;
                });
                await widget.service.markMovieFavorite(
                  widget.movie.id, 
                  widget.movie.isFavorite,
                );
              },
            ),
            Checkbox(
              value: widget.movie.isWatched,
              onChanged: (bool? value) async {
                setState(() {
                  widget.movie.isWatched = value ?? false;
                  if (widget.movie.isWatched) {
                    widget.movie.watchedDate = DateTime.now();
                  } else {
                    widget.movie.watchedDate = null;
                  }
                });
                await widget.service.markMovieWatched(
                  widget.movie.id, 
                  widget.movie.isWatched,
                );
              },
            ),
          ],
        ),
        onTap: widget.movie.summary != null ? () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(widget.movie.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.movie.stardate != null)
                    Text('Stardate: ${widget.movie.stardate!.toStringAsFixed(1)}'),
                  if (widget.movie.releaseDate != null)
                    Text('Released: ${DateFormat('MMM d, yyyy').format(widget.movie.releaseDate!)}'),
                  const SizedBox(height: 8),
                  Text(widget.movie.summary!),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        } : null,
      ),
    );
  }
}