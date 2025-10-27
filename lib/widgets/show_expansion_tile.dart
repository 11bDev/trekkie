import 'package:flutter/material.dart';
import '../models/star_trek_models.dart';
import '../services/star_trek_service.dart';
import 'season_expansion_tile.dart';
import 'captain_avatar.dart';

class ShowExpansionTile extends StatefulWidget {
  final StarTrekShow show;
  final StarTrekService service;
  final bool initiallyExpanded;
  final bool scrollToLastWatched;

  const ShowExpansionTile({
    super.key,
    required this.show,
    required this.service,
    this.initiallyExpanded = false,
    this.scrollToLastWatched = false,
  });

  @override
  State<ShowExpansionTile> createState() => _ShowExpansionTileState();
}

class _ShowExpansionTileState extends State<ShowExpansionTile> {
  final Map<int, GlobalKey> _seasonKeys = {};
  int? _targetSeasonNumber;
  bool _hasInitialized = false;
  final ExpansionTileController _controller = ExpansionTileController();

  @override
  void initState() {
    super.initState();
    _initializeScrolling();
    
    // If should be initially expanded, expand after frame is built
    if (widget.initiallyExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.expand();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ShowExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If scrollToLastWatched changed from false to true, initialize scrolling
    if (!oldWidget.scrollToLastWatched &&
        widget.scrollToLastWatched &&
        !_hasInitialized) {
      _initializeScrolling();
      // Expand the tile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.expand();
        }
      });
    }
  }

  void _initializeScrolling() {
    if (widget.scrollToLastWatched && !_hasInitialized) {
      _hasInitialized = true;
      _findTargetSeason();
    }
  }

  void _onExpansionChanged(bool expanded) {
    // When expansion completes and we have a target season, try to scroll
    if (expanded && _targetSeasonNumber != null && widget.scrollToLastWatched) {
      print('DEBUG: ExpansionTile expanded, waiting for children to render');
      // Wait for children to be fully rendered
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _scrollToTargetSeason();
        }
      });
    }
  }

  void _findTargetSeason() {
    print('DEBUG: Finding target season for ${widget.show.title}');
    // Find the last watched episode or first unwatched episode
    for (final season in widget.show.seasons) {
      final hasWatchedEpisodes = season.episodes.any((e) => e.isWatched);
      final hasUnwatchedEpisodes = season.episodes.any((e) => !e.isWatched);

      if (hasWatchedEpisodes && hasUnwatchedEpisodes) {
        // This season has both watched and unwatched - this is likely where we want to go
        _targetSeasonNumber = season.number;
        print(
          'DEBUG: Found current season ${season.number} for ${widget.show.title} (has both watched and unwatched)',
        );
        break;
      } else if (hasWatchedEpisodes) {
        // Track the last season with watched episodes
        _targetSeasonNumber = season.number;
        print(
          'DEBUG: Found completed season ${season.number} for ${widget.show.title}',
        );
      }
    }

    // If no watched episodes found, default to first season
    if (_targetSeasonNumber == null) {
      _targetSeasonNumber = widget.show.seasons.isNotEmpty
          ? widget.show.seasons.first.number
          : null;
      print(
        'DEBUG: No watched episodes, defaulting to season $_targetSeasonNumber for ${widget.show.title}',
      );
    }

    print(
      'DEBUG: Target season for ${widget.show.title} is $_targetSeasonNumber',
    );
    // Note: Scrolling will be triggered by onExpansionChanged callback
  }

  void _scrollToTargetSeason() {
    if (_targetSeasonNumber == null) {
      print('DEBUG: _targetSeasonNumber is null, cannot scroll');
      return;
    }

    final key = _seasonKeys[_targetSeasonNumber];
    if (key == null) {
      print('DEBUG: No key found for season $_targetSeasonNumber');
      print('DEBUG: Available season keys: ${_seasonKeys.keys.toList()}');
      return;
    }

    if (key.currentContext == null) {
      print(
        'DEBUG: Key exists but context is null for season $_targetSeasonNumber',
      );
      // Try again after a longer delay to allow children to render
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && key.currentContext != null) {
          print(
            'DEBUG: Retry successful, scrolling to season $_targetSeasonNumber',
          );
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.0,
          );
        } else if (mounted) {
          print('DEBUG: First retry failed, trying one more time');
          // Try one more time with even longer delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && key.currentContext != null) {
              print(
                'DEBUG: Second retry successful, scrolling to season $_targetSeasonNumber',
              );
              Scrollable.ensureVisible(
                key.currentContext!,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                alignment: 0.0,
              );
            } else {
              print(
                'DEBUG: All retries failed for season $_targetSeasonNumber',
              );
            }
          });
        }
      });
      return;
    }

    print(
      'DEBUG: Scrolling to season $_targetSeasonNumber for ${widget.show.title}',
    );
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.0, // Scroll to top of viewport
    );
  }

  @override
  Widget build(BuildContext context) {
    final allEpisodes = widget.show.seasons.expand((s) => s.episodes).toList();
    final watchedCount = allEpisodes.where((e) => e.isWatched).length;
    final totalCount = allEpisodes.length;
    final favoriteCount = allEpisodes.where((e) => e.isFavorite).length;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        controller: _controller,
        onExpansionChanged: _onExpansionChanged,
        leading: CaptainAvatar(
          showId: widget.show.id,
          size: 70,
          fallbackText: widget.show.abbreviation,
          fallbackColor: _getShowColor(widget.show.abbreviation),
        ),
        title: Text(
          widget.show.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.show.timelineStart.year} - ${widget.show.timelineEnd.year}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                  Text(' $favoriteCount', style: const TextStyle(fontSize: 16)),
                ],
              ],
            ),
          ],
        ),
        children: widget.show.seasons.asMap().entries.map((entry) {
          final season = entry.value;
          // Create key for each season
          _seasonKeys.putIfAbsent(season.number, () => GlobalKey());

          // Only expand the target season initially
          final shouldExpand =
              widget.scrollToLastWatched &&
              _targetSeasonNumber != null &&
              season.number == _targetSeasonNumber;

          return Container(
            key: _seasonKeys[season.number],
            child: SeasonExpansionTile(
              season: season,
              service: widget.service,
              initiallyExpanded: shouldExpand,
            ),
          );
        }).toList(),
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
