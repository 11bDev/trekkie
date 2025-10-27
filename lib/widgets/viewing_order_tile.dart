import 'package:flutter/material.dart';
import '../models/star_trek_models.dart';

class ViewingOrderTile extends StatelessWidget {
  final ViewingItem item;
  final int index;
  final VoidCallback? onSeriesTap;
  final VoidCallback? onMovieTap;

  const ViewingOrderTile({
    super.key,
    required this.item,
    required this.index,
    this.onSeriesTap,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSeries = item.type == 'series';
    final bool isMovie = item.type == 'movie';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: item.isOptional ? Colors.grey.shade600 : null,
          ),
        ),
        subtitle: _buildSubtitle(),
        trailing: item.isOptional
            ? Chip(
                label: const Text('Optional', style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.orange.shade100,
                labelStyle: TextStyle(color: Colors.orange.shade800),
              )
            : (isSeries || isMovie)
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade600,
              )
            : null,
        onTap: isSeries && onSeriesTap != null
            ? onSeriesTap
            : isMovie && onMovieTap != null
            ? onMovieTap
            : null,
        enabled: isSeries || isMovie,
      ),
    );
  }

  Widget _buildLeadingIcon() {
    Color backgroundColor;

    switch (item.type) {
      case 'movie':
        backgroundColor = Colors.amber.shade700;
        break;
      case 'series':
        backgroundColor = Colors.blue.shade600;
        break;
      case 'episode':
        backgroundColor = Colors.green.shade600;
        break;
      default:
        backgroundColor = Colors.grey.shade600;
    }

    if (item.isOptional) {
      backgroundColor = backgroundColor.withOpacity(0.6);
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (item.type == 'movie')
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.movie, color: backgroundColor, size: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    final children = <Widget>[];

    if (item.subtitle != null) {
      children.add(
        Text(
          item.subtitle!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: item.isOptional
                ? Colors.grey.shade500
                : Colors.blue.shade700,
          ),
        ),
      );
    }

    if (item.note != null) {
      children.add(
        Text(
          item.note!,
          style: TextStyle(
            fontSize: 13,
            color: item.isOptional
                ? Colors.grey.shade500
                : Colors.grey.shade600,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
