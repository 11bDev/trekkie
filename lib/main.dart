import 'package:flutter/material.dart';
import 'services/star_trek_service.dart';
import 'services/viewing_order_service.dart';
import 'models/star_trek_models.dart';
import 'widgets/show_expansion_tile.dart';
import 'widgets/movie_tile.dart';
import 'widgets/star_trek_icon.dart';
import 'widgets/viewing_order_tile.dart';
import 'widgets/captain_avatar.dart';
import 'widgets/welcome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TrekkieApp());
}

class TrekkieApp extends StatelessWidget {
  const TrekkieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trekkie - Star Trek Timeline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Star Trek blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontSize: 24),
          titleMedium: TextStyle(fontSize: 20),
          titleSmall: TextStyle(fontSize: 18),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontSize: 24),
          titleMedium: TextStyle(fontSize: 20),
          titleSmall: TextStyle(fontSize: 18),
        ),
      ),
      home: const TrekkieHomePage(),
    );
  }
}

class TrekkieHomePage extends StatefulWidget {
  const TrekkieHomePage({super.key});

  @override
  State<TrekkieHomePage> createState() => _TrekkieHomePageState();
}

class _TrekkieHomePageState extends State<TrekkieHomePage> {
  final StarTrekService _service = StarTrekService();
  List<StarTrekShow> _shows = [];
  List<Movie> _movies = [];
  Map<String, List<Movie>> _moviesByTimeline = {};
  List<ViewingEra> _viewingOrder = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
  final Map<String, GlobalKey> _showKeys = {};
  String? _scrollToShowId;
  String? _scrollToMovieId;
  final Map<String, bool> _movieTimelineExpanded = {};
  final Set<String> _expandedShows = {}; // Track which shows have been expanded

  @override
  void initState() {
    super.initState();
    _loadShows();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    if (!hasSeenWelcome && mounted) {
      // Wait a bit for the UI to settle
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WelcomeDialog(),
        );

        // Mark as seen
        await prefs.setBool('hasSeenWelcome', true);
      }
    }
  }

  Future<void> _loadShows() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get comprehensive Star Trek content
      final content = await _service.getStarTrekContent();
      final shows = content['shows'] as List<StarTrekShow>;
      final movies = content['movies'] as List<Movie>;
      final moviesByTimeline =
          content['moviesByTimeline'] as Map<String, List<Movie>>;

      // Load user preferences
      final watchedEpisodes = await _service.getWatchedEpisodes();
      final favoriteEpisodes = await _service.getFavoriteEpisodes();
      final watchedMovies = await _service.getWatchedMovies();
      final favoriteMovies = await _service.getFavoriteMovies();

      // Update episode states based on saved preferences
      for (final show in shows) {
        for (final season in show.seasons) {
          for (final episode in season.episodes) {
            episode.isWatched = watchedEpisodes.contains(episode.id);
            episode.isFavorite = favoriteEpisodes.contains(episode.id);
            if (episode.isWatched && episode.watchedDate == null) {
              episode.watchedDate =
                  DateTime.now(); // Default date for existing watched episodes
            }
          }
        }
      }

      // Update movie states based on saved preferences
      for (final movie in movies) {
        movie.isWatched = watchedMovies.contains(movie.id);
        movie.isFavorite = favoriteMovies.contains(movie.id);
        if (movie.isWatched && movie.watchedDate == null) {
          movie.watchedDate =
              DateTime.now(); // Default date for existing watched movies
        }
      }

      // Get recommended viewing order
      final viewingOrder = ViewingOrderService.getRecommendedViewingOrder();

      setState(() {
        _shows = shows;
        _movies = movies;
        _moviesByTimeline = moviesByTimeline;
        _viewingOrder = viewingOrder;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            StarTrekIcon(size: 32, color: Colors.amber.shade600),
            const SizedBox(width: 12),
            const Text(
              'Trekkie',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadShows,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildRecommendedView(),
                _buildTimelineView(),
                _buildMoviesView(),
                _buildStatsView(),
                _buildFavoritesView(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // Clear movie scroll target when navigating away from Movies tab
            if (index != 2) {
              _scrollToMovieId = null;
            }
            // Clear show scroll target when navigating away from By Series tab
            if (index != 1) {
              _scrollToShowId = null;
            }
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommended',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'By Series',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildRecommendedView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recommended viewing order for the best Star Trek experience',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _viewingOrder.length,
            itemBuilder: (context, index) {
              final era = _viewingOrder[index];
              return _buildEraSection(era);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEraSection(ViewingEra era) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              era.title.split('.')[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          era.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(era.description, style: const TextStyle(fontSize: 14)),
        children: era.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return ViewingOrderTile(
            item: item,
            index: index,
            onSeriesTap: item.type == 'series'
                ? () => _navigateToSeries(item.id)
                : null,
            onMovieTap: item.type == 'movie'
                ? () => _navigateToMovie(item.id)
                : null,
          );
        }).toList(),
      ),
    );
  }

  void _navigateToSeries(String seriesId) {
    // Map viewing order IDs to actual show IDs
    // Viewing order uses IDs like 'ent_all', 'snw_all' but shows use 'ent', 'snw'
    String actualShowId = seriesId;
    if (seriesId.endsWith('_all') ||
        seriesId.endsWith('_early') ||
        seriesId.endsWith('_late')) {
      actualShowId = seriesId.split('_')[0];
    }

    print('DEBUG: Navigating to series: $seriesId -> $actualShowId');

    // Switch to the "By Series" tab (index 1)
    setState(() {
      _selectedIndex = 1;
      _scrollToShowId = actualShowId;
      _expandedShows.add(actualShowId); // Mark this show as expanded
    });

    // The expansion will happen automatically via the controller
    // We'll clear the scroll target after a delay to prevent re-expansion on next navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _scrollToShowId = null;
          });
        }
      });
    });
  }

  void _navigateToMovie(String movieId) {
    print('DEBUG: Navigating to movie: $movieId');

    // Switch to the "Movies" tab and set expansion state
    setState(() {
      _selectedIndex = 2;
      _scrollToMovieId = movieId;

      // Find which timeline contains this movie and set it to expand
      for (final entry in _moviesByTimeline.entries) {
        final timeline = entry.key;
        final movies = entry.value;
        if (movies.any((movie) => movie.id == movieId)) {
          _movieTimelineExpanded[timeline] = true;
          print('DEBUG: Expanding timeline: $timeline for movie: $movieId');
        }
      }
    });
  }

  Widget _buildTimelineView() {
    return ListView.builder(
      itemCount: _shows.length,
      itemBuilder: (context, index) {
        final show = _shows[index];
        // Create a unique key for each show if it doesn't exist
        _showKeys.putIfAbsent(show.id, () => GlobalKey());

        final shouldExpand = show.id == _scrollToShowId;
        // Use unique key when expanding to force rebuild, but keep it stable after expansion
        final hasBeenExpanded = _expandedShows.contains(show.id);
        final tileKey = hasBeenExpanded
            ? Key('expanded-${show.id}')
            : (shouldExpand ? Key('expanding-${show.id}') : ValueKey(show.id));

        if (shouldExpand) {
          print('DEBUG: Building show ${show.title} with shouldExpand=true, key=$tileKey');
        }

        return Container(
          key: _showKeys[show.id],
          child: ShowExpansionTile(
            key: tileKey,
            show: show,
            service: _service,
            initiallyExpanded: shouldExpand,
            scrollToLastWatched: shouldExpand,
          ),
        );
      },
    );
  }

  Widget _buildMoviesView() {
    return ListView(
      children: _moviesByTimeline.entries.map((entry) {
        final timeline = entry.key;
        final movies = entry.value;

        // Get the current expansion state, defaulting to false
        final isExpanded = _movieTimelineExpanded[timeline] ?? false;

        // Use a unique key when expanding to force rebuild
        final key = isExpanded && _scrollToMovieId != null
            ? Key('$timeline-$_scrollToMovieId')
            : ValueKey(timeline);

        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 4,
          child: ExpansionTile(
            key: key,
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _movieTimelineExpanded[timeline] = expanded;
              });
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie, color: Colors.white),
            ),
            title: Text(
              timeline.replaceAll(' (Prime Timeline)', ''),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              '${movies.length} ${movies.length == 1 ? 'movie' : 'movies'}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            children: movies.map((movie) {
              return MovieTile(movie: movie, service: _service);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsView() {
    final allEpisodes = _shows
        .expand((s) => s.seasons.expand((season) => season.episodes))
        .toList();
    final watchedEpisodesCount = allEpisodes.where((e) => e.isWatched).length;
    final favoriteEpisodesCount = allEpisodes.where((e) => e.isFavorite).length;
    final totalEpisodesCount = allEpisodes.length;

    final watchedMoviesCount = _movies.where((m) => m.isWatched).length;
    final favoriteMoviesCount = _movies.where((m) => m.isFavorite).length;
    final totalMoviesCount = _movies.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Progress',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: totalEpisodesCount > 0
                        ? (watchedEpisodesCount / totalEpisodesCount).toDouble()
                        : 0.0,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Episodes: $watchedEpisodesCount / $totalEpisodesCount watched',
                  ),
                  Text(
                    'Movies: $watchedMoviesCount / $totalMoviesCount watched',
                  ),
                  Text(
                    '$favoriteEpisodesCount favorite episodes, $favoriteMoviesCount favorite movies',
                  ),
                  Text(
                    'Episodes: ${((watchedEpisodesCount / totalEpisodesCount) * 100).toStringAsFixed(1)}% complete',
                  ),
                  Text(
                    'Movies: ${totalMoviesCount > 0 ? ((watchedMoviesCount / totalMoviesCount) * 100).toStringAsFixed(1) : 0}% complete',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Progress by Series',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _shows.length,
              itemBuilder: (context, index) {
                final show = _shows[index];
                final episodes = show.seasons
                    .expand((s) => s.episodes)
                    .toList();
                final watched = episodes.where((e) => e.isWatched).length;
                final total = episodes.length;
                final progress = total > 0 ? watched / total : 0;

                return Card(
                  child: ListTile(
                    leading: CaptainAvatar(
                      showId: show.id,
                      size: 50,
                      fallbackText: show.abbreviation,
                      fallbackColor: _getShowColor(show.abbreviation),
                    ),
                    title: Text(show.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: progress.toDouble(),
                          backgroundColor: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$watched / $total episodes (${(progress * 100).toStringAsFixed(1)}%)',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesView() {
    final favoriteEpisodes = _shows
        .expand((s) => s.seasons.expand((season) => season.episodes))
        .where((e) => e.isFavorite)
        .toList();

    final favoriteMovies = _movies.where((m) => m.isFavorite).toList();

    if (favoriteEpisodes.isEmpty && favoriteMovies.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StarTrekIcon(size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Tap the star icon on episodes and movies to add them here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final allFavorites = <Widget>[];

    // Add favorite episodes
    for (final episode in favoriteEpisodes) {
      final show = _shows.firstWhere(
        (s) => s.seasons.any((season) => season.episodes.contains(episode)),
      );

      allFavorites.add(
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ListTile(
            leading: CaptainAvatar(
              showId: show.id,
              size: 50,
              fallbackText: show.abbreviation,
              fallbackColor: _getShowColor(show.abbreviation),
            ),
            title: Text(episode.title),
            subtitle: Text(
              '${show.title} - S${episode.seasonNumber}E${episode.episodeNumber}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber),
                if (episode.isWatched)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ),
      );
    }

    // Add favorite movies
    for (final movie in favoriteMovies) {
      allFavorites.add(
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: ListTile(
            leading: Stack(
              children: [
                CaptainAvatar(
                  showId: movie.id,
                  size: 50,
                  fallbackColor: Colors.amber.shade700,
                  fallbackText: 'M',
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(movie.title),
            subtitle: movie.stardate != null
                ? Text('Stardate: ${movie.stardate!.toStringAsFixed(1)}')
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber),
                if (movie.isWatched)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ),
      );
    }

    return ListView(children: allFavorites);
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
