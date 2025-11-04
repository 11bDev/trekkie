import 'dart:convert';
import '../models/star_trek_models.dart';
import 'star_trek_api_service.dart';
import 'movie_service.dart';
import 'firestore_service.dart';

class StarTrekService {
  final StarTrekApiService _apiService = StarTrekApiService();
  final FirestoreService _firestoreService = FirestoreService();

  // Get comprehensive Star Trek content including shows and movies
  Future<Map<String, dynamic>> getStarTrekContent() async {
    try {
      // Try to get enhanced data from API
      final shows = await _apiService.getComprehensiveStarTrekData();
      final movies = MovieService.getStarTrekMovies();

      return {
        'shows': shows,
        'movies': movies,
        'moviesByTimeline': MovieService.getMoviesByTimeline(),
      };
    } catch (e) {
      print('Error fetching Star Trek content: $e');
      // Fallback to static data
      return {
        'shows': getStarTrekShows(),
        'movies': MovieService.getStarTrekMovies(),
        'moviesByTimeline': MovieService.getMoviesByTimeline(),
      };
    }
  }

  // Static data for Star Trek shows in chronological order (fallback)
  static List<StarTrekShow> getStarTrekShows() {
    return [
      // Enterprise (2151-2155)
      StarTrekShow(
        id: 'ent',
        title: 'Star Trek: Enterprise',
        abbreviation: 'ENT',
        timelineStart: DateTime(2151),
        timelineEnd: DateTime(2155),
        seasons: [
          Season(number: 1, episodes: _generateEnterpriseS1Episodes()),
          Season(number: 2, episodes: _generateEnterpriseS2Episodes()),
          Season(number: 3, episodes: _generateEnterpriseS3Episodes()),
          Season(number: 4, episodes: _generateEnterpriseS4Episodes()),
        ],
      ),

      // Discovery Season 1-2 (2256-2258)
      StarTrekShow(
        id: 'dis_early',
        title: 'Star Trek: Discovery (Seasons 1-2)',
        abbreviation: 'DIS',
        timelineStart: DateTime(2256),
        timelineEnd: DateTime(2258),
        seasons: [
          Season(number: 1, episodes: _generateDiscoveryS1Episodes()),
          Season(number: 2, episodes: _generateDiscoveryS2Episodes()),
        ],
      ),

      // Strange New Worlds (2259-2260)
      StarTrekShow(
        id: 'snw',
        title: 'Star Trek: Strange New Worlds',
        abbreviation: 'SNW',
        timelineStart: DateTime(2259),
        timelineEnd: DateTime(2260),
        seasons: [
          Season(number: 1, episodes: _generateSNWS1Episodes()),
          Season(number: 2, episodes: _generateSNWS2Episodes()),
        ],
      ),

      // The Original Series (2266-2269)
      StarTrekShow(
        id: 'tos',
        title: 'Star Trek: The Original Series',
        abbreviation: 'TOS',
        timelineStart: DateTime(2266),
        timelineEnd: DateTime(2269),
        seasons: [
          Season(number: 1, episodes: _generateTOSS1Episodes()),
          Season(number: 2, episodes: _generateTOSS2Episodes()),
          Season(number: 3, episodes: _generateTOSS3Episodes()),
        ],
      ),

      // The Animated Series (2269-2270)
      StarTrekShow(
        id: 'tas',
        title: 'Star Trek: The Animated Series',
        abbreviation: 'TAS',
        timelineStart: DateTime(2269),
        timelineEnd: DateTime(2270),
        seasons: [
          Season(number: 1, episodes: _generateTASS1Episodes()),
          Season(number: 2, episodes: _generateTASS2Episodes()),
        ],
      ),

      // The Next Generation (2364-2370)
      StarTrekShow(
        id: 'tng',
        title: 'Star Trek: The Next Generation',
        abbreviation: 'TNG',
        timelineStart: DateTime(2364),
        timelineEnd: DateTime(2370),
        seasons: [
          Season(number: 1, episodes: _generateTNGS1Episodes()),
          Season(number: 2, episodes: _generateTNGS2Episodes()),
          Season(number: 3, episodes: _generateTNGS3Episodes()),
          Season(number: 4, episodes: _generateTNGS4Episodes()),
          Season(number: 5, episodes: _generateTNGS5Episodes()),
          Season(number: 6, episodes: _generateTNGS6Episodes()),
          Season(number: 7, episodes: _generateTNGS7Episodes()),
        ],
      ),

      // Deep Space Nine (2369-2375)
      StarTrekShow(
        id: 'ds9',
        title: 'Star Trek: Deep Space Nine',
        abbreviation: 'DS9',
        timelineStart: DateTime(2369),
        timelineEnd: DateTime(2375),
        seasons: [
          Season(number: 1, episodes: _generateDS9S1Episodes()),
          Season(number: 2, episodes: _generateDS9S2Episodes()),
          Season(number: 3, episodes: _generateDS9S3Episodes()),
          Season(number: 4, episodes: _generateDS9S4Episodes()),
          Season(number: 5, episodes: _generateDS9S5Episodes()),
          Season(number: 6, episodes: _generateDS9S6Episodes()),
          Season(number: 7, episodes: _generateDS9S7Episodes()),
        ],
      ),

      // Voyager (2371-2378)
      StarTrekShow(
        id: 'voy',
        title: 'Star Trek: Voyager',
        abbreviation: 'VOY',
        timelineStart: DateTime(2371),
        timelineEnd: DateTime(2378),
        seasons: [
          Season(number: 1, episodes: _generateVoyagerS1Episodes()),
          Season(number: 2, episodes: _generateVoyagerS2Episodes()),
          Season(number: 3, episodes: _generateVoyagerS3Episodes()),
          Season(number: 4, episodes: _generateVoyagerS4Episodes()),
          Season(number: 5, episodes: _generateVoyagerS5Episodes()),
          Season(number: 6, episodes: _generateVoyagerS6Episodes()),
          Season(number: 7, episodes: _generateVoyagerS7Episodes()),
        ],
      ),

      // Lower Decks (2380-2383)
      StarTrekShow(
        id: 'ld',
        title: 'Star Trek: Lower Decks',
        abbreviation: 'LD',
        timelineStart: DateTime(2380),
        timelineEnd: DateTime(2383),
        seasons: [
          Season(number: 1, episodes: _generateLowerDecksS1Episodes()),
          Season(number: 2, episodes: _generateLowerDecksS2Episodes()),
          Season(number: 3, episodes: _generateLowerDecksS3Episodes()),
          Season(number: 4, episodes: _generateLowerDecksS4Episodes()),
          Season(number: 5, episodes: _generateLowerDecksS5Episodes()),
        ],
      ),

      // Prodigy (2383-2384)
      StarTrekShow(
        id: 'pro',
        title: 'Star Trek: Prodigy',
        abbreviation: 'PRO',
        timelineStart: DateTime(2383),
        timelineEnd: DateTime(2384),
        seasons: [
          Season(number: 1, episodes: _generateProdigyS1Episodes()),
          Season(number: 2, episodes: _generateProdigyS2Episodes()),
        ],
      ),

      // Picard (2399-2401)
      StarTrekShow(
        id: 'pic',
        title: 'Star Trek: Picard',
        abbreviation: 'PIC',
        timelineStart: DateTime(2399),
        timelineEnd: DateTime(2401),
        seasons: [
          Season(number: 1, episodes: _generatePicardS1Episodes()),
          Season(number: 2, episodes: _generatePicardS2Episodes()),
          Season(number: 3, episodes: _generatePicardS3Episodes()),
        ],
      ),

      // Discovery Season 3+ (3188+)
      StarTrekShow(
        id: 'dis_future',
        title: 'Star Trek: Discovery (Seasons 3-5)',
        abbreviation: 'DIS',
        timelineStart: DateTime(3188),
        timelineEnd: DateTime(3190),
        seasons: [
          Season(number: 3, episodes: _generateDiscoveryS3Episodes()),
          Season(number: 4, episodes: _generateDiscoveryS4Episodes()),
          Season(number: 5, episodes: _generateDiscoveryS5Episodes()),
        ],
      ),
    ];
  }

  Future<void> markEpisodeWatched(String episodeId, bool watched) async {
    await _firestoreService.markEpisodeWatched(episodeId, watched);
  }

  Future<void> markEpisodeFavorite(String episodeId, bool favorite) async {
    await _firestoreService.markEpisodeFavorite(episodeId, favorite);
  }

  Future<List<String>> getWatchedEpisodes() async {
    return await _firestoreService.getWatchedEpisodes();
  }

  Future<List<String>> getFavoriteEpisodes() async {
    return await _firestoreService.getFavoriteEpisodes();
  }

  Future<void> markMovieWatched(String movieId, bool watched) async {
    await _firestoreService.markMovieWatched(movieId, watched);
  }

  Future<void> markMovieFavorite(String movieId, bool favorite) async {
    await _firestoreService.markMovieFavorite(movieId, favorite);
  }

  Future<List<String>> getWatchedMovies() async {
    return await _firestoreService.getWatchedMovies();
  }

  Future<List<String>> getFavoriteMovies() async {
    return await _firestoreService.getFavoriteMovies();
  }

  // Sample episode generators (abbreviated for brevity)
  static List<Episode> _generateTOSS1Episodes() {
    return [
      Episode(
        id: 'tos_s1_e1',
        title: 'The Man Trap',
        seasonNumber: 1,
        episodeNumber: 1,
      ),
      Episode(
        id: 'tos_s1_e2',
        title: 'Charlie X',
        seasonNumber: 1,
        episodeNumber: 2,
      ),
      Episode(
        id: 'tos_s1_e3',
        title: 'Where No Man Has Gone Before',
        seasonNumber: 1,
        episodeNumber: 3,
      ),
      // Add more episodes as needed
    ];
  }

  static List<Episode> _generateTOSS2Episodes() {
    return [
      Episode(
        id: 'tos_s2_e1',
        title: 'Amok Time',
        seasonNumber: 2,
        episodeNumber: 1,
      ),
      Episode(
        id: 'tos_s2_e2',
        title: 'Who Mourns for Adonais?',
        seasonNumber: 2,
        episodeNumber: 2,
      ),
      // Add more episodes as needed
    ];
  }

  static List<Episode> _generateTOSS3Episodes() {
    return [
      Episode(
        id: 'tos_s3_e1',
        title: 'Spock\'s Brain',
        seasonNumber: 3,
        episodeNumber: 1,
      ),
      Episode(
        id: 'tos_s3_e2',
        title: 'The Enterprise Incident',
        seasonNumber: 3,
        episodeNumber: 2,
      ),
      // Add more episodes as needed
    ];
  }

  static List<Episode> _generateTASS1Episodes() => [
    Episode(
      id: 'tas_s1_e1',
      title: 'Beyond the Farthest Star',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
    Episode(
      id: 'tas_s1_e2',
      title: 'Yesteryear',
      seasonNumber: 1,
      episodeNumber: 2,
    ),
  ];

  static List<Episode> _generateTASS2Episodes() => [
    Episode(
      id: 'tas_s2_e1',
      title: 'The Pirates of Orion',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
    Episode(id: 'tas_s2_e2', title: 'Bem', seasonNumber: 2, episodeNumber: 2),
  ];

  // Placeholder generators for other series (you can expand these)
  static List<Episode> _generateEnterpriseS1Episodes() => [
    Episode(
      id: 'ent_s1_e1',
      title: 'Broken Bow',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateEnterpriseS2Episodes() => [
    Episode(
      id: 'ent_s2_e1',
      title: 'Shockwave, Part II',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateEnterpriseS3Episodes() => [
    Episode(
      id: 'ent_s3_e1',
      title: 'The Xindi',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateEnterpriseS4Episodes() => [
    Episode(
      id: 'ent_s4_e1',
      title: 'Storm Front',
      seasonNumber: 4,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS1Episodes() => [
    Episode(
      id: 'tng_s1_e1',
      title: 'Encounter at Farpoint',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS2Episodes() => [
    Episode(
      id: 'tng_s2_e1',
      title: 'The Child',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS3Episodes() => [
    Episode(
      id: 'tng_s3_e1',
      title: 'Evolution',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS4Episodes() => [
    Episode(
      id: 'tng_s4_e1',
      title: 'The Best of Both Worlds, Part II',
      seasonNumber: 4,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS5Episodes() => [
    Episode(
      id: 'tng_s5_e1',
      title: 'Redemption II',
      seasonNumber: 5,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS6Episodes() => [
    Episode(
      id: 'tng_s6_e1',
      title: 'Time\'s Arrow, Part II',
      seasonNumber: 6,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateTNGS7Episodes() => [
    Episode(
      id: 'tng_s7_e1',
      title: 'Descent, Part II',
      seasonNumber: 7,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S1Episodes() => [
    Episode(
      id: 'ds9_s1_e1',
      title: 'Emissary',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S2Episodes() => [
    Episode(
      id: 'ds9_s2_e1',
      title: 'The Homecoming',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S3Episodes() => [
    Episode(
      id: 'ds9_s3_e1',
      title: 'The Search, Part I',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S4Episodes() => [
    Episode(
      id: 'ds9_s4_e1',
      title: 'The Way of the Warrior',
      seasonNumber: 4,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S5Episodes() => [
    Episode(
      id: 'ds9_s5_e1',
      title: 'Apocalypse Rising',
      seasonNumber: 5,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S6Episodes() => [
    Episode(
      id: 'ds9_s6_e1',
      title: 'A Time to Stand',
      seasonNumber: 6,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDS9S7Episodes() => [
    Episode(
      id: 'ds9_s7_e1',
      title: 'Image in the Sand',
      seasonNumber: 7,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS1Episodes() => [
    Episode(
      id: 'voy_s1_e1',
      title: 'Caretaker',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS2Episodes() => [
    Episode(
      id: 'voy_s2_e1',
      title: 'The 37\'s',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS3Episodes() => [
    Episode(
      id: 'voy_s3_e1',
      title: 'Basics, Part II',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS4Episodes() => [
    Episode(
      id: 'voy_s4_e1',
      title: 'Scorpion, Part II',
      seasonNumber: 4,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS5Episodes() => [
    Episode(id: 'voy_s5_e1', title: 'Night', seasonNumber: 5, episodeNumber: 1),
  ];

  static List<Episode> _generateVoyagerS6Episodes() => [
    Episode(
      id: 'voy_s6_e1',
      title: 'Equinox, Part II',
      seasonNumber: 6,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateVoyagerS7Episodes() => [
    Episode(
      id: 'voy_s7_e1',
      title: 'Unimatrix Zero, Part II',
      seasonNumber: 7,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDiscoveryS1Episodes() => [
    Episode(
      id: 'dis_s1_e1',
      title: 'The Vulcan Hello',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDiscoveryS2Episodes() => [
    Episode(
      id: 'dis_s2_e1',
      title: 'Brother',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDiscoveryS3Episodes() => [
    Episode(
      id: 'dis_s3_e1',
      title: 'That Hope Is You, Part 1',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDiscoveryS4Episodes() => [
    Episode(
      id: 'dis_s4_e1',
      title: 'Kobayashi Maru',
      seasonNumber: 4,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateDiscoveryS5Episodes() => [
    Episode(
      id: 'dis_s5_e1',
      title: 'Red Directive',
      seasonNumber: 5,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateSNWS1Episodes() => [
    Episode(
      id: 'snw_s1_e1',
      title: 'Strange New Worlds',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateSNWS2Episodes() => [
    Episode(
      id: 'snw_s2_e1',
      title: 'The Broken Circle',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateLowerDecksS1Episodes() => [
    Episode(
      id: 'ld_s1_e1',
      title: 'Second Contact',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateLowerDecksS2Episodes() => [
    Episode(
      id: 'ld_s2_e1',
      title: 'Strange Energies',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateLowerDecksS3Episodes() => [
    Episode(
      id: 'ld_s3_e1',
      title: 'Grounded',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateLowerDecksS4Episodes() => [
    Episode(id: 'ld_s4_e1', title: 'Twovix', seasonNumber: 4, episodeNumber: 1),
  ];

  static List<Episode> _generateLowerDecksS5Episodes() => [
    Episode(
      id: 'ld_s5_e1',
      title: 'Dos Cerritos',
      seasonNumber: 5,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateProdigyS1Episodes() => [
    Episode(
      id: 'pro_s1_e1',
      title: 'Lost and Found',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generateProdigyS2Episodes() => [
    Episode(
      id: 'pro_s2_e1',
      title: 'Into the Breach, Part I',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generatePicardS1Episodes() => [
    Episode(
      id: 'pic_s1_e1',
      title: 'Remembrance',
      seasonNumber: 1,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generatePicardS2Episodes() => [
    Episode(
      id: 'pic_s2_e1',
      title: 'The Star Gazer',
      seasonNumber: 2,
      episodeNumber: 1,
    ),
  ];

  static List<Episode> _generatePicardS3Episodes() => [
    Episode(
      id: 'pic_s3_e1',
      title: 'The Next Generation',
      seasonNumber: 3,
      episodeNumber: 1,
    ),
  ];
}
