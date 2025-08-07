import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/star_trek_models.dart';

class StarTrekApiService {
  static const String _stapiBaseUrl = 'https://stapi.co/api/v1/rest';
  static const String _subspaceBaseUrl = 'https://api.subspaceapi.com';

  // Fetch episodes from STAPI
  Future<List<Episode>> fetchEpisodesFromStapi(String seriesTitle) async {
    try {
      final response = await http.get(
        Uri.parse('$_stapiBaseUrl/episode/search?title=$seriesTitle&pageSize=1000'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final episodes = <Episode>[];
        
        if (data['episodes'] != null) {
          for (final episodeData in data['episodes']) {
            episodes.add(_parseStapiEpisode(episodeData));
          }
        }
        
        return episodes;
      }
    } catch (e) {
      print('Error fetching episodes from STAPI: $e');
    }
    return [];
  }

  // Fetch movies from STAPI
  Future<List<Movie>> fetchMoviesFromStapi() async {
    try {
      final response = await http.get(
        Uri.parse('$_stapiBaseUrl/movie/search?pageSize=100'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movies = <Movie>[];
        
        if (data['movies'] != null) {
          for (final movieData in data['movies']) {
            movies.add(_parseStapiMovie(movieData));
          }
        }
        
        return movies;
      }
    } catch (e) {
      print('Error fetching movies from STAPI: $e');
    }
    return [];
  }

  // Fetch data from Subspace API as backup/supplement
  Future<Map<String, dynamic>?> fetchFromSubspaceApi(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_subspaceBaseUrl/$endpoint'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error fetching from Subspace API: $e');
    }
    return null;
  }

  Episode _parseStapiEpisode(Map<String, dynamic> data) {
    return Episode(
      id: data['uid'] ?? '',
      title: data['title'] ?? 'Unknown Episode',
      seasonNumber: data['seasonNumber'] ?? 0,
      episodeNumber: data['episodeNumber'] ?? 0,
      stardate: _parseStardate(data['stardate']),
      airDate: _parseDate(data['usAirDate']),
      description: data['stardateFrom']?.toString(),
      summary: data['summary'],
      productionSerialNumber: data['productionSerialNumber'],
    );
  }

  Movie _parseStapiMovie(Map<String, dynamic> data) {
    return Movie(
      id: data['uid'] ?? '',
      title: data['title'] ?? 'Unknown Movie',
      stardate: _parseStardate(data['stardate']),
      releaseDate: _parseDate(data['usReleaseDate']),
      description: data['stardateFrom']?.toString(),
      summary: data['summary'],
    );
  }

  double? _parseStardate(dynamic stardate) {
    if (stardate == null) return null;
    if (stardate is num) return stardate.toDouble();
    if (stardate is String) {
      final parsed = double.tryParse(stardate);
      return parsed;
    }
    return null;
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get comprehensive Star Trek data with fallback to static data
  Future<List<StarTrekShow>> getComprehensiveStarTrekData() async {
    final shows = <StarTrekShow>[];
    
    // Try to fetch from APIs first, fall back to static data if needed
    try {
      // For now, we'll use a hybrid approach - static structure with API enhancement
      shows.addAll(await _getEnhancedStaticData());
    } catch (e) {
      print('Error fetching comprehensive data: $e');
      // Fall back to basic static data
      shows.addAll(_getBasicStaticData());
    }
    
    return shows;
  }

  Future<List<StarTrekShow>> _getEnhancedStaticData() async {
    // This would be enhanced with API data in a production app
    // For now, returning comprehensive static data with proper stardates
    return [
      // Enterprise (2151-2155)
      StarTrekShow(
        id: 'ent',
        title: 'Star Trek: Enterprise',
        abbreviation: 'ENT',
        timelineStart: DateTime(2151),
        timelineEnd: DateTime(2155),
        seasons: [
          Season(number: 1, episodes: _getEnterpriseS1Episodes()),
          Season(number: 2, episodes: _getEnterpriseS2Episodes()),
          Season(number: 3, episodes: _getEnterpriseS3Episodes()),
          Season(number: 4, episodes: _getEnterpriseS4Episodes()),
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
          Season(number: 1, episodes: _getDiscoveryS1Episodes()),
          Season(number: 2, episodes: _getDiscoveryS2Episodes()),
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
          Season(number: 1, episodes: _getSNWS1Episodes()),
          Season(number: 2, episodes: _getSNWS2Episodes()),
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
          Season(number: 1, episodes: _getTOSS1Episodes()),
          Season(number: 2, episodes: _getTOSS2Episodes()),
          Season(number: 3, episodes: _getTOSS3Episodes()),
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
          Season(number: 1, episodes: _getTNGS1Episodes()),
          Season(number: 2, episodes: _getTNGS2Episodes()),
          Season(number: 3, episodes: _getTNGS3Episodes()),
          Season(number: 4, episodes: _getTNGS4Episodes()),
          Season(number: 5, episodes: _getTNGS5Episodes()),
          Season(number: 6, episodes: _getTNGS6Episodes()),
          Season(number: 7, episodes: _getTNGS7Episodes()),
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
          Season(number: 1, episodes: _getDS9S1Episodes()),
          Season(number: 2, episodes: _getDS9S2Episodes()),
          Season(number: 3, episodes: _getDS9S3Episodes()),
          Season(number: 4, episodes: _getDS9S4Episodes()),
          Season(number: 5, episodes: _getDS9S5Episodes()),
          Season(number: 6, episodes: _getDS9S6Episodes()),
          Season(number: 7, episodes: _getDS9S7Episodes()),
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
          Season(number: 1, episodes: _getVoyagerS1Episodes()),
          Season(number: 2, episodes: _getVoyagerS2Episodes()),
          Season(number: 3, episodes: _getVoyagerS3Episodes()),
          Season(number: 4, episodes: _getVoyagerS4Episodes()),
          Season(number: 5, episodes: _getVoyagerS5Episodes()),
          Season(number: 6, episodes: _getVoyagerS6Episodes()),
          Season(number: 7, episodes: _getVoyagerS7Episodes()),
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
          Season(number: 1, episodes: _getLowerDecksS1Episodes()),
          Season(number: 2, episodes: _getLowerDecksS2Episodes()),
          Season(number: 3, episodes: _getLowerDecksS3Episodes()),
          Season(number: 4, episodes: _getLowerDecksS4Episodes()),
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
          Season(number: 1, episodes: _getProdigyS1Episodes()),
          Season(number: 2, episodes: _getProdigyS2Episodes()),
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
          Season(number: 1, episodes: _getPicardS1Episodes()),
          Season(number: 2, episodes: _getPicardS2Episodes()),
          Season(number: 3, episodes: _getPicardS3Episodes()),
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
          Season(number: 3, episodes: _getDiscoveryS3Episodes()),
          Season(number: 4, episodes: _getDiscoveryS4Episodes()),
          Season(number: 5, episodes: _getDiscoveryS5Episodes()),
        ],
      ),
    ];
  }

  List<StarTrekShow> _getBasicStaticData() {
    // Fallback basic data
    return [
      StarTrekShow(
        id: 'tos',
        title: 'Star Trek: The Original Series',
        abbreviation: 'TOS',
        timelineStart: DateTime(2266),
        timelineEnd: DateTime(2269),
        seasons: [
          Season(number: 1, episodes: [
            Episode(id: 'tos_s1_e1', title: 'The Man Trap', seasonNumber: 1, episodeNumber: 1, stardate: 1513.1),
          ]),
        ],
      ),
    ];
  }

  // Helper function to generate episodes quickly
  List<Episode> _generateEpisodes(String seriesId, int seasonNumber, List<String> titles) {
    return titles.asMap().entries.map((entry) {
      final index = entry.key;
      final title = entry.value;
      return Episode(
        id: '${seriesId}_s${seasonNumber}_e${index + 1}',
        title: title,
        seasonNumber: seasonNumber,
        episodeNumber: index + 1,
      );
    }).toList();
  }

  // Enhanced episode data with proper stardates
  List<Episode> _getTOSS1Episodes() {
    return [
      Episode(id: 'tos_s1_e1', title: 'The Man Trap', seasonNumber: 1, episodeNumber: 1, stardate: 1513.1, airDate: DateTime(1966, 9, 8)),
      Episode(id: 'tos_s1_e2', title: 'Charlie X', seasonNumber: 1, episodeNumber: 2, stardate: 1533.6, airDate: DateTime(1966, 9, 15)),
      Episode(id: 'tos_s1_e3', title: 'Where No Man Has Gone Before', seasonNumber: 1, episodeNumber: 3, stardate: 1312.4, airDate: DateTime(1966, 9, 22)),
      Episode(id: 'tos_s1_e4', title: 'The Naked Time', seasonNumber: 1, episodeNumber: 4, stardate: 1704.2, airDate: DateTime(1966, 9, 29)),
      Episode(id: 'tos_s1_e5', title: 'The Enemy Within', seasonNumber: 1, episodeNumber: 5, stardate: 1672.1, airDate: DateTime(1966, 10, 6)),
      Episode(id: 'tos_s1_e6', title: 'Mudd\'s Women', seasonNumber: 1, episodeNumber: 6, stardate: 1329.8, airDate: DateTime(1966, 10, 13)),
      Episode(id: 'tos_s1_e7', title: 'What Are Little Girls Made Of?', seasonNumber: 1, episodeNumber: 7, stardate: 2712.4, airDate: DateTime(1966, 10, 20)),
      Episode(id: 'tos_s1_e8', title: 'Miri', seasonNumber: 1, episodeNumber: 8, stardate: 2713.5, airDate: DateTime(1966, 10, 27)),
      Episode(id: 'tos_s1_e9', title: 'Dagger of the Mind', seasonNumber: 1, episodeNumber: 9, stardate: 2715.1, airDate: DateTime(1966, 11, 3)),
      Episode(id: 'tos_s1_e10', title: 'The Corbomite Maneuver', seasonNumber: 1, episodeNumber: 10, stardate: 1512.2, airDate: DateTime(1966, 11, 10)),
      Episode(id: 'tos_s1_e11', title: 'The Menagerie, Part I', seasonNumber: 1, episodeNumber: 11, stardate: 3012.4, airDate: DateTime(1966, 11, 17)),
      Episode(id: 'tos_s1_e12', title: 'The Menagerie, Part II', seasonNumber: 1, episodeNumber: 12, stardate: 3013.1, airDate: DateTime(1966, 11, 24)),
      Episode(id: 'tos_s1_e13', title: 'The Conscience of the King', seasonNumber: 1, episodeNumber: 13, stardate: 2817.6, airDate: DateTime(1966, 12, 8)),
      Episode(id: 'tos_s1_e14', title: 'Balance of Terror', seasonNumber: 1, episodeNumber: 14, stardate: 1709.2, airDate: DateTime(1966, 12, 15)),
      Episode(id: 'tos_s1_e15', title: 'Shore Leave', seasonNumber: 1, episodeNumber: 15, stardate: 3025.3, airDate: DateTime(1966, 12, 29)),
      Episode(id: 'tos_s1_e16', title: 'The Galileo Seven', seasonNumber: 1, episodeNumber: 16, stardate: 2821.5, airDate: DateTime(1967, 1, 5)),
      Episode(id: 'tos_s1_e17', title: 'The Squire of Gothos', seasonNumber: 1, episodeNumber: 17, stardate: 2124.5, airDate: DateTime(1967, 1, 12)),
      Episode(id: 'tos_s1_e18', title: 'Arena', seasonNumber: 1, episodeNumber: 18, stardate: 3045.6, airDate: DateTime(1967, 1, 19)),
      Episode(id: 'tos_s1_e19', title: 'Tomorrow Is Yesterday', seasonNumber: 1, episodeNumber: 19, stardate: 3113.2, airDate: DateTime(1967, 1, 26)),
      Episode(id: 'tos_s1_e20', title: 'Court Martial', seasonNumber: 1, episodeNumber: 20, stardate: 2947.3, airDate: DateTime(1967, 2, 2)),
      Episode(id: 'tos_s1_e21', title: 'The Return of the Archons', seasonNumber: 1, episodeNumber: 21, stardate: 3156.2, airDate: DateTime(1967, 2, 9)),
      Episode(id: 'tos_s1_e22', title: 'Space Seed', seasonNumber: 1, episodeNumber: 22, stardate: 3141.9, airDate: DateTime(1967, 2, 16)),
      Episode(id: 'tos_s1_e23', title: 'A Taste of Armageddon', seasonNumber: 1, episodeNumber: 23, stardate: 3192.1, airDate: DateTime(1967, 2, 23)),
      Episode(id: 'tos_s1_e24', title: 'This Side of Paradise', seasonNumber: 1, episodeNumber: 24, stardate: 3417.3, airDate: DateTime(1967, 3, 2)),
      Episode(id: 'tos_s1_e25', title: 'The Devil in the Dark', seasonNumber: 1, episodeNumber: 25, stardate: 3196.1, airDate: DateTime(1967, 3, 9)),
      Episode(id: 'tos_s1_e26', title: 'Errand of Mercy', seasonNumber: 1, episodeNumber: 26, stardate: 3198.4, airDate: DateTime(1967, 3, 23)),
      Episode(id: 'tos_s1_e27', title: 'The Alternative Factor', seasonNumber: 1, episodeNumber: 27, stardate: 3087.6, airDate: DateTime(1967, 3, 30)),
      Episode(id: 'tos_s1_e28', title: 'The City on the Edge of Forever', seasonNumber: 1, episodeNumber: 28, stardate: 3134.0, airDate: DateTime(1967, 4, 6)),
      Episode(id: 'tos_s1_e29', title: 'Operation -- Annihilate!', seasonNumber: 1, episodeNumber: 29, stardate: 3287.2, airDate: DateTime(1967, 4, 13)),
    ];
  }

  List<Episode> _getTOSS2Episodes() {
    return [
      Episode(id: 'tos_s2_e1', title: 'Amok Time', seasonNumber: 2, episodeNumber: 1, stardate: 3372.7, airDate: DateTime(1967, 9, 15)),
      Episode(id: 'tos_s2_e2', title: 'Who Mourns for Adonais?', seasonNumber: 2, episodeNumber: 2, stardate: 3468.1, airDate: DateTime(1967, 9, 22)),
      Episode(id: 'tos_s2_e3', title: 'The Changeling', seasonNumber: 2, episodeNumber: 3, stardate: 3541.9, airDate: DateTime(1967, 9, 29)),
      Episode(id: 'tos_s2_e4', title: 'Mirror, Mirror', seasonNumber: 2, episodeNumber: 4, airDate: DateTime(1967, 10, 6)),
      Episode(id: 'tos_s2_e5', title: 'The Apple', seasonNumber: 2, episodeNumber: 5, stardate: 3715.3, airDate: DateTime(1967, 10, 13)),
      Episode(id: 'tos_s2_e6', title: 'The Doomsday Machine', seasonNumber: 2, episodeNumber: 6, stardate: 4202.9, airDate: DateTime(1967, 10, 20)),
      Episode(id: 'tos_s2_e7', title: 'Catspaw', seasonNumber: 2, episodeNumber: 7, stardate: 3018.2, airDate: DateTime(1967, 10, 27)),
      Episode(id: 'tos_s2_e8', title: 'I, Mudd', seasonNumber: 2, episodeNumber: 8, stardate: 4513.3, airDate: DateTime(1967, 11, 3)),
      Episode(id: 'tos_s2_e9', title: 'Metamorphosis', seasonNumber: 2, episodeNumber: 9, stardate: 3219.8, airDate: DateTime(1967, 11, 10)),
      Episode(id: 'tos_s2_e10', title: 'Journey to Babel', seasonNumber: 2, episodeNumber: 10, stardate: 3842.3, airDate: DateTime(1967, 11, 17)),
      Episode(id: 'tos_s2_e11', title: 'Friday\'s Child', seasonNumber: 2, episodeNumber: 11, stardate: 3497.2, airDate: DateTime(1967, 12, 1)),
      Episode(id: 'tos_s2_e12', title: 'The Deadly Years', seasonNumber: 2, episodeNumber: 12, stardate: 3478.2, airDate: DateTime(1967, 12, 8)),
      Episode(id: 'tos_s2_e13', title: 'Obsession', seasonNumber: 2, episodeNumber: 13, stardate: 3619.2, airDate: DateTime(1967, 12, 15)),
      Episode(id: 'tos_s2_e14', title: 'Wolf in the Fold', seasonNumber: 2, episodeNumber: 14, stardate: 3614.9, airDate: DateTime(1967, 12, 22)),
      Episode(id: 'tos_s2_e15', title: 'The Trouble with Tribbles', seasonNumber: 2, episodeNumber: 15, stardate: 4523.3, airDate: DateTime(1967, 12, 29)),
      Episode(id: 'tos_s2_e16', title: 'The Gamesters of Triskelion', seasonNumber: 2, episodeNumber: 16, stardate: 3211.7, airDate: DateTime(1968, 1, 5)),
      Episode(id: 'tos_s2_e17', title: 'A Piece of the Action', seasonNumber: 2, episodeNumber: 17, stardate: 4598.0, airDate: DateTime(1968, 1, 12)),
      Episode(id: 'tos_s2_e18', title: 'The Immunity Syndrome', seasonNumber: 2, episodeNumber: 18, stardate: 4307.1, airDate: DateTime(1968, 1, 19)),
      Episode(id: 'tos_s2_e19', title: 'A Private Little War', seasonNumber: 2, episodeNumber: 19, stardate: 4211.4, airDate: DateTime(1968, 2, 2)),
      Episode(id: 'tos_s2_e20', title: 'Return to Tomorrow', seasonNumber: 2, episodeNumber: 20, stardate: 4768.3, airDate: DateTime(1968, 2, 9)),
      Episode(id: 'tos_s2_e21', title: 'Patterns of Force', seasonNumber: 2, episodeNumber: 21, stardate: 2534.0, airDate: DateTime(1968, 2, 16)),
      Episode(id: 'tos_s2_e22', title: 'By Any Other Name', seasonNumber: 2, episodeNumber: 22, stardate: 4657.5, airDate: DateTime(1968, 2, 23)),
      Episode(id: 'tos_s2_e23', title: 'The Omega Glory', seasonNumber: 2, episodeNumber: 23, airDate: DateTime(1968, 3, 1)),
      Episode(id: 'tos_s2_e24', title: 'The Ultimate Computer', seasonNumber: 2, episodeNumber: 24, stardate: 4729.4, airDate: DateTime(1968, 3, 8)),
      Episode(id: 'tos_s2_e25', title: 'Bread and Circuses', seasonNumber: 2, episodeNumber: 25, stardate: 4040.7, airDate: DateTime(1968, 3, 15)),
      Episode(id: 'tos_s2_e26', title: 'Assignment: Earth', seasonNumber: 2, episodeNumber: 26, airDate: DateTime(1968, 3, 29)),
    ];
  }

  List<Episode> _getTOSS3Episodes() {
    return [
      Episode(id: 'tos_s3_e1', title: 'Spock\'s Brain', seasonNumber: 3, episodeNumber: 1, stardate: 5431.4, airDate: DateTime(1968, 9, 20)),
      Episode(id: 'tos_s3_e2', title: 'The Enterprise Incident', seasonNumber: 3, episodeNumber: 2, stardate: 5027.3, airDate: DateTime(1968, 9, 27)),
      Episode(id: 'tos_s3_e3', title: 'The Paradise Syndrome', seasonNumber: 3, episodeNumber: 3, stardate: 4842.6, airDate: DateTime(1968, 10, 4)),
      Episode(id: 'tos_s3_e4', title: 'And the Children Shall Lead', seasonNumber: 3, episodeNumber: 4, stardate: 5029.5, airDate: DateTime(1968, 10, 11)),
      Episode(id: 'tos_s3_e5', title: 'Is There in Truth No Beauty?', seasonNumber: 3, episodeNumber: 5, stardate: 5630.7, airDate: DateTime(1968, 10, 18)),
      Episode(id: 'tos_s3_e6', title: 'Spectre of the Gun', seasonNumber: 3, episodeNumber: 6, stardate: 4385.3, airDate: DateTime(1968, 10, 25)),
      Episode(id: 'tos_s3_e7', title: 'Day of the Dove', seasonNumber: 3, episodeNumber: 7, airDate: DateTime(1968, 11, 1)),
      Episode(id: 'tos_s3_e8', title: 'For the World Is Hollow and I Have Touched the Sky', seasonNumber: 3, episodeNumber: 8, stardate: 5476.3, airDate: DateTime(1968, 11, 8)),
      Episode(id: 'tos_s3_e9', title: 'The Tholian Web', seasonNumber: 3, episodeNumber: 9, stardate: 5693.2, airDate: DateTime(1968, 11, 15)),
      Episode(id: 'tos_s3_e10', title: 'Plato\'s Stepchildren', seasonNumber: 3, episodeNumber: 10, stardate: 5784.2, airDate: DateTime(1968, 11, 22)),
      Episode(id: 'tos_s3_e11', title: 'Wink of an Eye', seasonNumber: 3, episodeNumber: 11, stardate: 5710.5, airDate: DateTime(1968, 11, 29)),
      Episode(id: 'tos_s3_e12', title: 'The Empath', seasonNumber: 3, episodeNumber: 12, stardate: 5121.5, airDate: DateTime(1968, 12, 6)),
      Episode(id: 'tos_s3_e13', title: 'Elaan of Troyius', seasonNumber: 3, episodeNumber: 13, stardate: 4372.5, airDate: DateTime(1968, 12, 20)),
      Episode(id: 'tos_s3_e14', title: 'Whom Gods Destroy', seasonNumber: 3, episodeNumber: 14, stardate: 5718.3, airDate: DateTime(1969, 1, 3)),
      Episode(id: 'tos_s3_e15', title: 'Let That Be Your Last Battlefield', seasonNumber: 3, episodeNumber: 15, stardate: 5730.2, airDate: DateTime(1969, 1, 10)),
      Episode(id: 'tos_s3_e16', title: 'The Mark of Gideon', seasonNumber: 3, episodeNumber: 16, stardate: 5423.4, airDate: DateTime(1969, 1, 17)),
      Episode(id: 'tos_s3_e17', title: 'That Which Survives', seasonNumber: 3, episodeNumber: 17, airDate: DateTime(1969, 1, 24)),
      Episode(id: 'tos_s3_e18', title: 'The Lights of Zetar', seasonNumber: 3, episodeNumber: 18, stardate: 5725.3, airDate: DateTime(1969, 1, 31)),
      Episode(id: 'tos_s3_e19', title: 'Requiem for Methuselah', seasonNumber: 3, episodeNumber: 19, stardate: 5843.7, airDate: DateTime(1969, 2, 14)),
      Episode(id: 'tos_s3_e20', title: 'The Way to Eden', seasonNumber: 3, episodeNumber: 20, stardate: 5832.3, airDate: DateTime(1969, 2, 21)),
      Episode(id: 'tos_s3_e21', title: 'Requiem for Methuselah', seasonNumber: 3, episodeNumber: 21, stardate: 5843.7, airDate: DateTime(1969, 2, 14)),
      Episode(id: 'tos_s3_e22', title: 'The Savage Curtain', seasonNumber: 3, episodeNumber: 22, stardate: 5906.4, airDate: DateTime(1969, 3, 7)),
      Episode(id: 'tos_s3_e23', title: 'All Our Yesterdays', seasonNumber: 3, episodeNumber: 23, stardate: 5943.7, airDate: DateTime(1969, 3, 14)),
      Episode(id: 'tos_s3_e24', title: 'Turnabout Intruder', seasonNumber: 3, episodeNumber: 24, stardate: 5928.5, airDate: DateTime(1969, 6, 3)),
    ];
  }

  // Enterprise episodes with complete seasons
  List<Episode> _getEnterpriseS1Episodes() => [
    Episode(id: 'ent_s1_e1', title: 'Broken Bow', seasonNumber: 1, episodeNumber: 1, airDate: DateTime(2001, 9, 26)),
    Episode(id: 'ent_s1_e2', title: 'Fight or Flight', seasonNumber: 1, episodeNumber: 2, airDate: DateTime(2001, 10, 3)),
    Episode(id: 'ent_s1_e3', title: 'Strange New World', seasonNumber: 1, episodeNumber: 3, airDate: DateTime(2001, 10, 10)),
    Episode(id: 'ent_s1_e4', title: 'Unexpected', seasonNumber: 1, episodeNumber: 4, airDate: DateTime(2001, 10, 17)),
    Episode(id: 'ent_s1_e5', title: 'Terra Nova', seasonNumber: 1, episodeNumber: 5, airDate: DateTime(2001, 10, 24)),
    Episode(id: 'ent_s1_e6', title: 'The Andorian Incident', seasonNumber: 1, episodeNumber: 6, airDate: DateTime(2001, 10, 31)),
    Episode(id: 'ent_s1_e7', title: 'Breaking the Ice', seasonNumber: 1, episodeNumber: 7, airDate: DateTime(2001, 11, 7)),
    Episode(id: 'ent_s1_e8', title: 'Civilization', seasonNumber: 1, episodeNumber: 8, airDate: DateTime(2001, 11, 14)),
    Episode(id: 'ent_s1_e9', title: 'Fortunate Son', seasonNumber: 1, episodeNumber: 9, airDate: DateTime(2001, 11, 21)),
    Episode(id: 'ent_s1_e10', title: 'Cold Front', seasonNumber: 1, episodeNumber: 10, airDate: DateTime(2001, 11, 28)),
    Episode(id: 'ent_s1_e11', title: 'Silent Enemy', seasonNumber: 1, episodeNumber: 11, airDate: DateTime(2002, 1, 16)),
    Episode(id: 'ent_s1_e12', title: 'Dear Doctor', seasonNumber: 1, episodeNumber: 12, airDate: DateTime(2002, 1, 23)),
    Episode(id: 'ent_s1_e13', title: 'Sleeping Dogs', seasonNumber: 1, episodeNumber: 13, airDate: DateTime(2002, 1, 30)),
    Episode(id: 'ent_s1_e14', title: 'Shadows of P\'Jem', seasonNumber: 1, episodeNumber: 14, airDate: DateTime(2002, 2, 6)),
    Episode(id: 'ent_s1_e15', title: 'Shuttlepod One', seasonNumber: 1, episodeNumber: 15, airDate: DateTime(2002, 2, 13)),
    Episode(id: 'ent_s1_e16', title: 'Fusion', seasonNumber: 1, episodeNumber: 16, airDate: DateTime(2002, 2, 27)),
    Episode(id: 'ent_s1_e17', title: 'Rogue Planet', seasonNumber: 1, episodeNumber: 17, airDate: DateTime(2002, 3, 20)),
    Episode(id: 'ent_s1_e18', title: 'Acquisition', seasonNumber: 1, episodeNumber: 18, airDate: DateTime(2002, 3, 27)),
    Episode(id: 'ent_s1_e19', title: 'Oasis', seasonNumber: 1, episodeNumber: 19, airDate: DateTime(2002, 4, 3)),
    Episode(id: 'ent_s1_e20', title: 'Detained', seasonNumber: 1, episodeNumber: 20, airDate: DateTime(2002, 4, 24)),
    Episode(id: 'ent_s1_e21', title: 'Vox Sola', seasonNumber: 1, episodeNumber: 21, airDate: DateTime(2002, 5, 1)),
    Episode(id: 'ent_s1_e22', title: 'Fallen Hero', seasonNumber: 1, episodeNumber: 22, airDate: DateTime(2002, 5, 8)),
    Episode(id: 'ent_s1_e23', title: 'Desert Crossing', seasonNumber: 1, episodeNumber: 23, airDate: DateTime(2002, 5, 8)),
    Episode(id: 'ent_s1_e24', title: 'Two Days and Two Nights', seasonNumber: 1, episodeNumber: 24, airDate: DateTime(2002, 5, 15)),
    Episode(id: 'ent_s1_e25', title: 'Shockwave', seasonNumber: 1, episodeNumber: 25, airDate: DateTime(2002, 5, 22)),
  ];
  
  List<Episode> _getEnterpriseS2Episodes() => [
    Episode(id: 'ent_s2_e1', title: 'Shockwave, Part II', seasonNumber: 2, episodeNumber: 1, airDate: DateTime(2002, 9, 18)),
    Episode(id: 'ent_s2_e2', title: 'Carbon Creek', seasonNumber: 2, episodeNumber: 2, airDate: DateTime(2002, 9, 25)),
    Episode(id: 'ent_s2_e3', title: 'Minefield', seasonNumber: 2, episodeNumber: 3, airDate: DateTime(2002, 10, 2)),
    Episode(id: 'ent_s2_e4', title: 'Dead Stop', seasonNumber: 2, episodeNumber: 4, airDate: DateTime(2002, 10, 9)),
    Episode(id: 'ent_s2_e5', title: 'A Night in Sickbay', seasonNumber: 2, episodeNumber: 5, airDate: DateTime(2002, 10, 16)),
    Episode(id: 'ent_s2_e6', title: 'Marauders', seasonNumber: 2, episodeNumber: 6, airDate: DateTime(2002, 10, 30)),
    Episode(id: 'ent_s2_e7', title: 'The Seventh', seasonNumber: 2, episodeNumber: 7, airDate: DateTime(2002, 11, 6)),
    Episode(id: 'ent_s2_e8', title: 'The Communicator', seasonNumber: 2, episodeNumber: 8, airDate: DateTime(2002, 11, 13)),
    Episode(id: 'ent_s2_e9', title: 'Singularity', seasonNumber: 2, episodeNumber: 9, airDate: DateTime(2002, 11, 20)),
    Episode(id: 'ent_s2_e10', title: 'Vanishing Point', seasonNumber: 2, episodeNumber: 10, airDate: DateTime(2002, 11, 27)),
    Episode(id: 'ent_s2_e11', title: 'Precious Cargo', seasonNumber: 2, episodeNumber: 11, airDate: DateTime(2002, 12, 11)),
    Episode(id: 'ent_s2_e12', title: 'The Catwalk', seasonNumber: 2, episodeNumber: 12, airDate: DateTime(2002, 12, 18)),
    Episode(id: 'ent_s2_e13', title: 'Dawn', seasonNumber: 2, episodeNumber: 13, airDate: DateTime(2003, 1, 8)),
    Episode(id: 'ent_s2_e14', title: 'Stigma', seasonNumber: 2, episodeNumber: 14, airDate: DateTime(2003, 2, 5)),
    Episode(id: 'ent_s2_e15', title: 'Cease Fire', seasonNumber: 2, episodeNumber: 15, airDate: DateTime(2003, 2, 12)),
    Episode(id: 'ent_s2_e16', title: 'Future Tense', seasonNumber: 2, episodeNumber: 16, airDate: DateTime(2003, 2, 19)),
    Episode(id: 'ent_s2_e17', title: 'Canamar', seasonNumber: 2, episodeNumber: 17, airDate: DateTime(2003, 2, 26)),
    Episode(id: 'ent_s2_e18', title: 'The Crossing', seasonNumber: 2, episodeNumber: 18, airDate: DateTime(2003, 4, 2)),
    Episode(id: 'ent_s2_e19', title: 'Judgment', seasonNumber: 2, episodeNumber: 19, airDate: DateTime(2003, 4, 9)),
    Episode(id: 'ent_s2_e20', title: 'Horizon', seasonNumber: 2, episodeNumber: 20, airDate: DateTime(2003, 4, 16)),
    Episode(id: 'ent_s2_e21', title: 'The Breach', seasonNumber: 2, episodeNumber: 21, airDate: DateTime(2003, 4, 23)),
    Episode(id: 'ent_s2_e22', title: 'Cogenitor', seasonNumber: 2, episodeNumber: 22, airDate: DateTime(2003, 4, 30)),
    Episode(id: 'ent_s2_e23', title: 'Regeneration', seasonNumber: 2, episodeNumber: 23, airDate: DateTime(2003, 5, 7)),
    Episode(id: 'ent_s2_e24', title: 'First Flight', seasonNumber: 2, episodeNumber: 24, airDate: DateTime(2003, 5, 14)),
    Episode(id: 'ent_s2_e25', title: 'Bounty', seasonNumber: 2, episodeNumber: 25, airDate: DateTime(2003, 5, 14)),
    Episode(id: 'ent_s2_e26', title: 'The Expanse', seasonNumber: 2, episodeNumber: 26, airDate: DateTime(2003, 5, 21)),
  ];
  
  List<Episode> _getEnterpriseS3Episodes() => [
    Episode(id: 'ent_s3_e1', title: 'The Xindi', seasonNumber: 3, episodeNumber: 1, airDate: DateTime(2003, 9, 10)),
    Episode(id: 'ent_s3_e2', title: 'Anomaly', seasonNumber: 3, episodeNumber: 2, airDate: DateTime(2003, 9, 17)),
    Episode(id: 'ent_s3_e3', title: 'Extinction', seasonNumber: 3, episodeNumber: 3, airDate: DateTime(2003, 9, 24)),
    Episode(id: 'ent_s3_e4', title: 'Rajiin', seasonNumber: 3, episodeNumber: 4, airDate: DateTime(2003, 10, 1)),
    Episode(id: 'ent_s3_e5', title: 'Impulse', seasonNumber: 3, episodeNumber: 5, airDate: DateTime(2003, 10, 8)),
    Episode(id: 'ent_s3_e6', title: 'Exile', seasonNumber: 3, episodeNumber: 6, airDate: DateTime(2003, 10, 15)),
    Episode(id: 'ent_s3_e7', title: 'The Shipment', seasonNumber: 3, episodeNumber: 7, airDate: DateTime(2003, 10, 29)),
    Episode(id: 'ent_s3_e8', title: 'Twilight', seasonNumber: 3, episodeNumber: 8, airDate: DateTime(2003, 11, 5)),
    Episode(id: 'ent_s3_e9', title: 'North Star', seasonNumber: 3, episodeNumber: 9, airDate: DateTime(2003, 11, 12)),
    Episode(id: 'ent_s3_e10', title: 'Similitude', seasonNumber: 3, episodeNumber: 10, airDate: DateTime(2003, 11, 19)),
    Episode(id: 'ent_s3_e11', title: 'Carpenter Street', seasonNumber: 3, episodeNumber: 11, airDate: DateTime(2003, 11, 26)),
    Episode(id: 'ent_s3_e12', title: 'Chosen Realm', seasonNumber: 3, episodeNumber: 12, airDate: DateTime(2004, 1, 14)),
    Episode(id: 'ent_s3_e13', title: 'Proving Ground', seasonNumber: 3, episodeNumber: 13, airDate: DateTime(2004, 1, 21)),
    Episode(id: 'ent_s3_e14', title: 'Stratagem', seasonNumber: 3, episodeNumber: 14, airDate: DateTime(2004, 2, 4)),
    Episode(id: 'ent_s3_e15', title: 'Harbinger', seasonNumber: 3, episodeNumber: 15, airDate: DateTime(2004, 2, 11)),
    Episode(id: 'ent_s3_e16', title: 'Doctor\'s Orders', seasonNumber: 3, episodeNumber: 16, airDate: DateTime(2004, 2, 18)),
    Episode(id: 'ent_s3_e17', title: 'Hatchery', seasonNumber: 3, episodeNumber: 17, airDate: DateTime(2004, 2, 25)),
    Episode(id: 'ent_s3_e18', title: 'Azati Prime', seasonNumber: 3, episodeNumber: 18, airDate: DateTime(2004, 3, 3)),
    Episode(id: 'ent_s3_e19', title: 'Damage', seasonNumber: 3, episodeNumber: 19, airDate: DateTime(2004, 4, 21)),
    Episode(id: 'ent_s3_e20', title: 'The Forgotten', seasonNumber: 3, episodeNumber: 20, airDate: DateTime(2004, 4, 28)),
    Episode(id: 'ent_s3_e21', title: 'E²', seasonNumber: 3, episodeNumber: 21, airDate: DateTime(2004, 5, 5)),
    Episode(id: 'ent_s3_e22', title: 'The Council', seasonNumber: 3, episodeNumber: 22, airDate: DateTime(2004, 5, 12)),
    Episode(id: 'ent_s3_e23', title: 'Countdown', seasonNumber: 3, episodeNumber: 23, airDate: DateTime(2004, 5, 19)),
    Episode(id: 'ent_s3_e24', title: 'Zero Hour', seasonNumber: 3, episodeNumber: 24, airDate: DateTime(2004, 5, 26)),
  ];
  
  List<Episode> _getEnterpriseS4Episodes() => [
    Episode(id: 'ent_s4_e1', title: 'Storm Front', seasonNumber: 4, episodeNumber: 1, airDate: DateTime(2004, 10, 8)),
    Episode(id: 'ent_s4_e2', title: 'Storm Front, Part II', seasonNumber: 4, episodeNumber: 2, airDate: DateTime(2004, 10, 15)),
    Episode(id: 'ent_s4_e3', title: 'Home', seasonNumber: 4, episodeNumber: 3, airDate: DateTime(2004, 10, 22)),
    Episode(id: 'ent_s4_e4', title: 'Borderland', seasonNumber: 4, episodeNumber: 4, airDate: DateTime(2004, 10, 29)),
    Episode(id: 'ent_s4_e5', title: 'Cold Station 12', seasonNumber: 4, episodeNumber: 5, airDate: DateTime(2004, 11, 5)),
    Episode(id: 'ent_s4_e6', title: 'The Augments', seasonNumber: 4, episodeNumber: 6, airDate: DateTime(2004, 11, 12)),
    Episode(id: 'ent_s4_e7', title: 'The Forge', seasonNumber: 4, episodeNumber: 7, airDate: DateTime(2004, 11, 19)),
    Episode(id: 'ent_s4_e8', title: 'Awakening', seasonNumber: 4, episodeNumber: 8, airDate: DateTime(2004, 11, 26)),
    Episode(id: 'ent_s4_e9', title: 'Kir\'Shara', seasonNumber: 4, episodeNumber: 9, airDate: DateTime(2004, 12, 3)),
    Episode(id: 'ent_s4_e10', title: 'Daedalus', seasonNumber: 4, episodeNumber: 10, airDate: DateTime(2005, 1, 14)),
    Episode(id: 'ent_s4_e11', title: 'Observer Effect', seasonNumber: 4, episodeNumber: 11, airDate: DateTime(2005, 1, 21)),
    Episode(id: 'ent_s4_e12', title: 'Babel One', seasonNumber: 4, episodeNumber: 12, airDate: DateTime(2005, 1, 28)),
    Episode(id: 'ent_s4_e13', title: 'United', seasonNumber: 4, episodeNumber: 13, airDate: DateTime(2005, 2, 4)),
    Episode(id: 'ent_s4_e14', title: 'The Aenar', seasonNumber: 4, episodeNumber: 14, airDate: DateTime(2005, 2, 11)),
    Episode(id: 'ent_s4_e15', title: 'Affliction', seasonNumber: 4, episodeNumber: 15, airDate: DateTime(2005, 2, 18)),
    Episode(id: 'ent_s4_e16', title: 'Divergence', seasonNumber: 4, episodeNumber: 16, airDate: DateTime(2005, 2, 25)),
    Episode(id: 'ent_s4_e17', title: 'Bound', seasonNumber: 4, episodeNumber: 17, airDate: DateTime(2005, 4, 15)),
    Episode(id: 'ent_s4_e18', title: 'In a Mirror, Darkly', seasonNumber: 4, episodeNumber: 18, airDate: DateTime(2005, 4, 22)),
    Episode(id: 'ent_s4_e19', title: 'In a Mirror, Darkly, Part II', seasonNumber: 4, episodeNumber: 19, airDate: DateTime(2005, 4, 29)),
    Episode(id: 'ent_s4_e20', title: 'Demons', seasonNumber: 4, episodeNumber: 20, airDate: DateTime(2005, 5, 6)),
    Episode(id: 'ent_s4_e21', title: 'Terra Prime', seasonNumber: 4, episodeNumber: 21, airDate: DateTime(2005, 5, 13)),
    Episode(id: 'ent_s4_e22', title: 'These Are the Voyages...', seasonNumber: 4, episodeNumber: 22, airDate: DateTime(2005, 5, 13)),
  ];

  List<Episode> _getDiscoveryS1Episodes() => [
    Episode(id: 'dis_s1_e1', title: 'The Vulcan Hello', seasonNumber: 1, episodeNumber: 1, stardate: 1207.3, airDate: DateTime(2017, 9, 24)),
    Episode(id: 'dis_s1_e2', title: 'Battle at the Binary Stars', seasonNumber: 1, episodeNumber: 2, stardate: 1207.3, airDate: DateTime(2017, 9, 24)),
    Episode(id: 'dis_s1_e3', title: 'Context Is for Kings', seasonNumber: 1, episodeNumber: 3, airDate: DateTime(2017, 10, 1)),
    Episode(id: 'dis_s1_e4', title: 'The Butcher\'s Knife Cares Not for the Lamb\'s Cry', seasonNumber: 1, episodeNumber: 4, airDate: DateTime(2017, 10, 8)),
    Episode(id: 'dis_s1_e5', title: 'Choose Your Pain', seasonNumber: 1, episodeNumber: 5, airDate: DateTime(2017, 10, 15)),
    Episode(id: 'dis_s1_e6', title: 'Lethe', seasonNumber: 1, episodeNumber: 6, airDate: DateTime(2017, 10, 22)),
    Episode(id: 'dis_s1_e7', title: 'Magic to Make the Sanest Man Go Mad', seasonNumber: 1, episodeNumber: 7, airDate: DateTime(2017, 10, 29)),
    Episode(id: 'dis_s1_e8', title: 'Si Vis Pacem, Para Bellum', seasonNumber: 1, episodeNumber: 8, airDate: DateTime(2017, 11, 5)),
    Episode(id: 'dis_s1_e9', title: 'Into the Forest I Go', seasonNumber: 1, episodeNumber: 9, airDate: DateTime(2017, 11, 12)),
    Episode(id: 'dis_s1_e10', title: 'Despite Yourself', seasonNumber: 1, episodeNumber: 10, airDate: DateTime(2018, 1, 7)),
    Episode(id: 'dis_s1_e11', title: 'The Wolf Inside', seasonNumber: 1, episodeNumber: 11, airDate: DateTime(2018, 1, 14)),
    Episode(id: 'dis_s1_e12', title: 'Vaulting Ambition', seasonNumber: 1, episodeNumber: 12, airDate: DateTime(2018, 1, 21)),
    Episode(id: 'dis_s1_e13', title: 'What\'s Past Is Prologue', seasonNumber: 1, episodeNumber: 13, airDate: DateTime(2018, 1, 28)),
    Episode(id: 'dis_s1_e14', title: 'The War Without, the War Within', seasonNumber: 1, episodeNumber: 14, airDate: DateTime(2018, 2, 4)),
    Episode(id: 'dis_s1_e15', title: 'Will You Take My Hand?', seasonNumber: 1, episodeNumber: 15, airDate: DateTime(2018, 2, 11)),
  ];
  
  List<Episode> _getDiscoveryS2Episodes() => [
    Episode(id: 'dis_s2_e1', title: 'Brother', seasonNumber: 2, episodeNumber: 1, stardate: 1029.46, airDate: DateTime(2019, 1, 17)),
    Episode(id: 'dis_s2_e2', title: 'New Eden', seasonNumber: 2, episodeNumber: 2, stardate: 1065.04, airDate: DateTime(2019, 1, 24)),
    Episode(id: 'dis_s2_e3', title: 'Point of Light', seasonNumber: 2, episodeNumber: 3, stardate: 1014.72, airDate: DateTime(2019, 1, 31)),
    Episode(id: 'dis_s2_e4', title: 'An Obol for Charon', seasonNumber: 2, episodeNumber: 4, stardate: 1076.57, airDate: DateTime(2019, 2, 7)),
    Episode(id: 'dis_s2_e5', title: 'Saints of Imperfection', seasonNumber: 2, episodeNumber: 5, stardate: 1081.82, airDate: DateTime(2019, 2, 14)),
    Episode(id: 'dis_s2_e6', title: 'The Sound of Thunder', seasonNumber: 2, episodeNumber: 6, stardate: 1059.94, airDate: DateTime(2019, 2, 21)),
    Episode(id: 'dis_s2_e7', title: 'Light and Shadows', seasonNumber: 2, episodeNumber: 7, stardate: 1138.5, airDate: DateTime(2019, 2, 28)),
    Episode(id: 'dis_s2_e8', title: 'If Memory Serves', seasonNumber: 2, episodeNumber: 8, stardate: 1149.1, airDate: DateTime(2019, 3, 7)),
    Episode(id: 'dis_s2_e9', title: 'Project Daedalus', seasonNumber: 2, episodeNumber: 9, stardate: 1201.7, airDate: DateTime(2019, 3, 14)),
    Episode(id: 'dis_s2_e10', title: 'The Red Angel', seasonNumber: 2, episodeNumber: 10, stardate: 1203.7, airDate: DateTime(2019, 3, 21)),
    Episode(id: 'dis_s2_e11', title: 'Perpetual Infinity', seasonNumber: 2, episodeNumber: 11, stardate: 1204.25, airDate: DateTime(2019, 3, 28)),
    Episode(id: 'dis_s2_e12', title: 'Through the Valley of Shadows', seasonNumber: 2, episodeNumber: 12, stardate: 1204.58, airDate: DateTime(2019, 4, 4)),
    Episode(id: 'dis_s2_e13', title: 'Such Sweet Sorrow', seasonNumber: 2, episodeNumber: 13, stardate: 1205.02, airDate: DateTime(2019, 4, 11)),
    Episode(id: 'dis_s2_e14', title: 'Such Sweet Sorrow, Part 2', seasonNumber: 2, episodeNumber: 14, stardate: 1205.1, airDate: DateTime(2019, 4, 18)),
  ];
  
  List<Episode> _getDiscoveryS3Episodes() => [
    Episode(id: 'dis_s3_e1', title: 'That Hope Is You, Part 1', seasonNumber: 3, episodeNumber: 1, airDate: DateTime(2020, 10, 15)),
    Episode(id: 'dis_s3_e2', title: 'Far From Home', seasonNumber: 3, episodeNumber: 2, airDate: DateTime(2020, 10, 22)),
    Episode(id: 'dis_s3_e3', title: 'People of Earth', seasonNumber: 3, episodeNumber: 3, airDate: DateTime(2020, 10, 29)),
    Episode(id: 'dis_s3_e4', title: 'Forget Me Not', seasonNumber: 3, episodeNumber: 4, airDate: DateTime(2020, 11, 5)),
    Episode(id: 'dis_s3_e5', title: 'Die Trying', seasonNumber: 3, episodeNumber: 5, airDate: DateTime(2020, 11, 12)),
    Episode(id: 'dis_s3_e6', title: 'Scavengers', seasonNumber: 3, episodeNumber: 6, airDate: DateTime(2020, 11, 19)),
    Episode(id: 'dis_s3_e7', title: 'Unification III', seasonNumber: 3, episodeNumber: 7, airDate: DateTime(2020, 11, 26)),
    Episode(id: 'dis_s3_e8', title: 'The Sanctuary', seasonNumber: 3, episodeNumber: 8, airDate: DateTime(2020, 12, 3)),
    Episode(id: 'dis_s3_e9', title: 'Terra Firma, Part 1', seasonNumber: 3, episodeNumber: 9, airDate: DateTime(2020, 12, 10)),
    Episode(id: 'dis_s3_e10', title: 'Terra Firma, Part 2', seasonNumber: 3, episodeNumber: 10, airDate: DateTime(2020, 12, 17)),
    Episode(id: 'dis_s3_e11', title: 'Su\'Kal', seasonNumber: 3, episodeNumber: 11, airDate: DateTime(2021, 1, 7)),
    Episode(id: 'dis_s3_e12', title: 'There Is a Tide...', seasonNumber: 3, episodeNumber: 12, airDate: DateTime(2021, 1, 14)),
    Episode(id: 'dis_s3_e13', title: 'That Hope Is You, Part 2', seasonNumber: 3, episodeNumber: 13, airDate: DateTime(2021, 1, 7)),
  ];
  
  List<Episode> _getDiscoveryS4Episodes() => [
    Episode(id: 'dis_s4_e1', title: 'Kobayashi Maru', seasonNumber: 4, episodeNumber: 1, airDate: DateTime(2021, 11, 18)),
    Episode(id: 'dis_s4_e2', title: 'Anomaly', seasonNumber: 4, episodeNumber: 2, airDate: DateTime(2021, 11, 25)),
    Episode(id: 'dis_s4_e3', title: 'Choose to Live', seasonNumber: 4, episodeNumber: 3, airDate: DateTime(2021, 12, 2)),
    Episode(id: 'dis_s4_e4', title: 'All Is Possible', seasonNumber: 4, episodeNumber: 4, airDate: DateTime(2021, 12, 9)),
    Episode(id: 'dis_s4_e5', title: 'The Examples', seasonNumber: 4, episodeNumber: 5, airDate: DateTime(2021, 12, 16)),
    Episode(id: 'dis_s4_e6', title: 'Stormy Weather', seasonNumber: 4, episodeNumber: 6, airDate: DateTime(2021, 12, 30)),
    Episode(id: 'dis_s4_e7', title: '...But to Connect', seasonNumber: 4, episodeNumber: 7, airDate: DateTime(2022, 2, 10)),
    Episode(id: 'dis_s4_e8', title: 'All In', seasonNumber: 4, episodeNumber: 8, airDate: DateTime(2022, 2, 17)),
    Episode(id: 'dis_s4_e9', title: 'Rubicon', seasonNumber: 4, episodeNumber: 9, airDate: DateTime(2022, 2, 24)),
    Episode(id: 'dis_s4_e10', title: 'The Galactic Barrier', seasonNumber: 4, episodeNumber: 10, airDate: DateTime(2022, 3, 3)),
    Episode(id: 'dis_s4_e11', title: 'Rosetta', seasonNumber: 4, episodeNumber: 11, airDate: DateTime(2022, 3, 10)),
    Episode(id: 'dis_s4_e12', title: 'Species Ten-C', seasonNumber: 4, episodeNumber: 12, airDate: DateTime(2022, 3, 17)),
    Episode(id: 'dis_s4_e13', title: 'Coming Home', seasonNumber: 4, episodeNumber: 13, airDate: DateTime(2022, 3, 17)),
  ];
  
  List<Episode> _getDiscoveryS5Episodes() => [
    Episode(id: 'dis_s5_e1', title: 'Red Directive', seasonNumber: 5, episodeNumber: 1, airDate: DateTime(2024, 4, 4)),
    Episode(id: 'dis_s5_e2', title: 'Under the Twin Moons', seasonNumber: 5, episodeNumber: 2, airDate: DateTime(2024, 4, 11)),
    Episode(id: 'dis_s5_e3', title: 'Jinaal', seasonNumber: 5, episodeNumber: 3, airDate: DateTime(2024, 4, 18)),
    Episode(id: 'dis_s5_e4', title: 'Face the Strange', seasonNumber: 5, episodeNumber: 4, airDate: DateTime(2024, 4, 25)),
    Episode(id: 'dis_s5_e5', title: 'Mirrors', seasonNumber: 5, episodeNumber: 5, airDate: DateTime(2024, 5, 2)),
    Episode(id: 'dis_s5_e6', title: 'Whistlespeak', seasonNumber: 5, episodeNumber: 6, airDate: DateTime(2024, 5, 9)),
    Episode(id: 'dis_s5_e7', title: 'Erigah', seasonNumber: 5, episodeNumber: 7, airDate: DateTime(2024, 5, 16)),
    Episode(id: 'dis_s5_e8', title: 'Labyrinths', seasonNumber: 5, episodeNumber: 8, airDate: DateTime(2024, 5, 23)),
    Episode(id: 'dis_s5_e9', title: 'Lagrange Point', seasonNumber: 5, episodeNumber: 9, airDate: DateTime(2024, 5, 30)),
    Episode(id: 'dis_s5_e10', title: 'Life, Itself', seasonNumber: 5, episodeNumber: 10, airDate: DateTime(2024, 5, 30)),
  ];

  List<Episode> _getSNWS1Episodes() => [
    Episode(id: 'snw_s1_e1', title: 'Strange New Worlds', seasonNumber: 1, episodeNumber: 1, stardate: 2259.42, airDate: DateTime(2022, 5, 5)),
    Episode(id: 'snw_s1_e2', title: 'Children of the Comet', seasonNumber: 1, episodeNumber: 2, stardate: 2259.44, airDate: DateTime(2022, 5, 12)),
    Episode(id: 'snw_s1_e3', title: 'Ghosts of Illyria', seasonNumber: 1, episodeNumber: 3, stardate: 2259.45, airDate: DateTime(2022, 5, 19)),
    Episode(id: 'snw_s1_e4', title: 'Memento Mori', seasonNumber: 1, episodeNumber: 4, stardate: 2259.46, airDate: DateTime(2022, 5, 26)),
    Episode(id: 'snw_s1_e5', title: 'Spock Amok', seasonNumber: 1, episodeNumber: 5, stardate: 2259.47, airDate: DateTime(2022, 6, 2)),
    Episode(id: 'snw_s1_e6', title: 'Lift Us Where Suffering Cannot Reach', seasonNumber: 1, episodeNumber: 6, stardate: 2259.48, airDate: DateTime(2022, 6, 9)),
    Episode(id: 'snw_s1_e7', title: 'The Serene Squall', seasonNumber: 1, episodeNumber: 7, stardate: 2259.49, airDate: DateTime(2022, 6, 16)),
    Episode(id: 'snw_s1_e8', title: 'The Elysian Kingdom', seasonNumber: 1, episodeNumber: 8, stardate: 2259.50, airDate: DateTime(2022, 6, 23)),
    Episode(id: 'snw_s1_e9', title: 'All Those Who Wander', seasonNumber: 1, episodeNumber: 9, stardate: 2259.51, airDate: DateTime(2022, 6, 30)),
    Episode(id: 'snw_s1_e10', title: 'A Quality of Mercy', seasonNumber: 1, episodeNumber: 10, stardate: 2259.52, airDate: DateTime(2022, 7, 7)),
  ];
  
  List<Episode> _getSNWS2Episodes() => [
    Episode(id: 'snw_s2_e1', title: 'The Broken Circle', seasonNumber: 2, episodeNumber: 1, stardate: 2259.44, airDate: DateTime(2023, 6, 15)),
    Episode(id: 'snw_s2_e2', title: 'Ad Astra per Aspera', seasonNumber: 2, episodeNumber: 2, stardate: 2259.45, airDate: DateTime(2023, 6, 22)),
    Episode(id: 'snw_s2_e3', title: 'Tomorrow and Tomorrow and Tomorrow', seasonNumber: 2, episodeNumber: 3, stardate: 2259.46, airDate: DateTime(2023, 6, 29)),
    Episode(id: 'snw_s2_e4', title: 'Among the Lotus Eaters', seasonNumber: 2, episodeNumber: 4, stardate: 2259.47, airDate: DateTime(2023, 7, 6)),
    Episode(id: 'snw_s2_e5', title: 'Charades', seasonNumber: 2, episodeNumber: 5, stardate: 2259.48, airDate: DateTime(2023, 7, 13)),
    Episode(id: 'snw_s2_e6', title: 'Lost in Translation', seasonNumber: 2, episodeNumber: 6, stardate: 2259.49, airDate: DateTime(2023, 7, 20)),
    Episode(id: 'snw_s2_e7', title: 'Those Old Scientists', seasonNumber: 2, episodeNumber: 7, stardate: 2259.50, airDate: DateTime(2023, 7, 27)),
    Episode(id: 'snw_s2_e8', title: 'Under the Cloak of War', seasonNumber: 2, episodeNumber: 8, stardate: 2259.51, airDate: DateTime(2023, 8, 3)),
    Episode(id: 'snw_s2_e9', title: 'Subspace Rhapsody', seasonNumber: 2, episodeNumber: 9, stardate: 2259.52, airDate: DateTime(2023, 8, 3)),
    Episode(id: 'snw_s2_e10', title: 'Hegemony', seasonNumber: 2, episodeNumber: 10, stardate: 2259.53, airDate: DateTime(2023, 8, 10)),
  ];

  List<Episode> _getTNGS1Episodes() => [
    Episode(id: 'tng_s1_e1', title: 'Encounter at Farpoint', seasonNumber: 1, episodeNumber: 1, stardate: 41153.7, airDate: DateTime(1987, 9, 28)),
    Episode(id: 'tng_s1_e2', title: 'The Naked Now', seasonNumber: 1, episodeNumber: 2, stardate: 41209.2, airDate: DateTime(1987, 10, 5)),
    Episode(id: 'tng_s1_e3', title: 'Code of Honor', seasonNumber: 1, episodeNumber: 3, stardate: 41235.25, airDate: DateTime(1987, 10, 12)),
    Episode(id: 'tng_s1_e4', title: 'The Last Outpost', seasonNumber: 1, episodeNumber: 4, stardate: 41386.4, airDate: DateTime(1987, 10, 19)),
    Episode(id: 'tng_s1_e5', title: 'Where No One Has Gone Before', seasonNumber: 1, episodeNumber: 5, stardate: 41263.1, airDate: DateTime(1987, 10, 26)),
    Episode(id: 'tng_s1_e6', title: 'Lonely Among Us', seasonNumber: 1, episodeNumber: 6, stardate: 41249.3, airDate: DateTime(1987, 11, 2)),
    Episode(id: 'tng_s1_e7', title: 'Justice', seasonNumber: 1, episodeNumber: 7, stardate: 41255.6, airDate: DateTime(1987, 11, 9)),
    Episode(id: 'tng_s1_e8', title: 'The Battle', seasonNumber: 1, episodeNumber: 8, stardate: 41723.9, airDate: DateTime(1987, 11, 16)),
    Episode(id: 'tng_s1_e9', title: 'Hide and Q', seasonNumber: 1, episodeNumber: 9, stardate: 41590.5, airDate: DateTime(1987, 11, 23)),
    Episode(id: 'tng_s1_e10', title: 'Haven', seasonNumber: 1, episodeNumber: 10, stardate: 41294.5, airDate: DateTime(1987, 11, 30)),
    Episode(id: 'tng_s1_e11', title: 'The Big Goodbye', seasonNumber: 1, episodeNumber: 11, stardate: 41997.7, airDate: DateTime(1988, 1, 11)),
    Episode(id: 'tng_s1_e12', title: 'Datalore', seasonNumber: 1, episodeNumber: 12, stardate: 41242.4, airDate: DateTime(1988, 1, 18)),
    Episode(id: 'tng_s1_e13', title: 'Angel One', seasonNumber: 1, episodeNumber: 13, stardate: 41636.9, airDate: DateTime(1988, 1, 25)),
    Episode(id: 'tng_s1_e14', title: '11001001', seasonNumber: 1, episodeNumber: 14, stardate: 41365.9, airDate: DateTime(1988, 2, 1)),
    Episode(id: 'tng_s1_e15', title: 'Too Short a Season', seasonNumber: 1, episodeNumber: 15, stardate: 41309.5, airDate: DateTime(1988, 2, 8)),
    Episode(id: 'tng_s1_e16', title: 'When the Bough Breaks', seasonNumber: 1, episodeNumber: 16, stardate: 41509.1, airDate: DateTime(1988, 2, 15)),
    Episode(id: 'tng_s1_e17', title: 'Home Soil', seasonNumber: 1, episodeNumber: 17, stardate: 41463.9, airDate: DateTime(1988, 2, 22)),
    Episode(id: 'tng_s1_e18', title: 'Coming of Age', seasonNumber: 1, episodeNumber: 18, stardate: 41416.2, airDate: DateTime(1988, 3, 14)),
    Episode(id: 'tng_s1_e19', title: 'Heart of Glory', seasonNumber: 1, episodeNumber: 19, stardate: 41503.7, airDate: DateTime(1988, 3, 21)),
    Episode(id: 'tng_s1_e20', title: 'The Arsenal of Freedom', seasonNumber: 1, episodeNumber: 20, stardate: 41798.2, airDate: DateTime(1988, 4, 11)),
    Episode(id: 'tng_s1_e21', title: 'Symbiosis', seasonNumber: 1, episodeNumber: 21, airDate: DateTime(1988, 4, 18)),
    Episode(id: 'tng_s1_e22', title: 'Skin of Evil', seasonNumber: 1, episodeNumber: 22, stardate: 41601.3, airDate: DateTime(1988, 4, 25)),
    Episode(id: 'tng_s1_e23', title: 'We\'ll Always Have Paris', seasonNumber: 1, episodeNumber: 23, stardate: 41697.9, airDate: DateTime(1988, 5, 2)),
    Episode(id: 'tng_s1_e24', title: 'Conspiracy', seasonNumber: 1, episodeNumber: 24, stardate: 41775.5, airDate: DateTime(1988, 5, 9)),
    Episode(id: 'tng_s1_e25', title: 'The Neutral Zone', seasonNumber: 1, episodeNumber: 25, stardate: 41986.0, airDate: DateTime(1988, 5, 16)),
  ];
  
  List<Episode> _getTNGS2Episodes() => [
    Episode(id: 'tng_s2_e1', title: 'The Child', seasonNumber: 2, episodeNumber: 1, stardate: 42073.1, airDate: DateTime(1988, 11, 21)),
    Episode(id: 'tng_s2_e2', title: 'Where Silence Has Lease', seasonNumber: 2, episodeNumber: 2, stardate: 42193.6, airDate: DateTime(1988, 11, 28)),
    Episode(id: 'tng_s2_e3', title: 'Elementary, Dear Data', seasonNumber: 2, episodeNumber: 3, stardate: 42286.3, airDate: DateTime(1988, 12, 5)),
    Episode(id: 'tng_s2_e4', title: 'The Outrageous Okona', seasonNumber: 2, episodeNumber: 4, stardate: 42402.7, airDate: DateTime(1988, 12, 12)),
    Episode(id: 'tng_s2_e5', title: 'Loud as a Whisper', seasonNumber: 2, episodeNumber: 5, stardate: 42477.2, airDate: DateTime(1989, 1, 9)),
    Episode(id: 'tng_s2_e6', title: 'The Schizoid Man', seasonNumber: 2, episodeNumber: 6, stardate: 42437.5, airDate: DateTime(1989, 1, 23)),
    Episode(id: 'tng_s2_e7', title: 'Unnatural Selection', seasonNumber: 2, episodeNumber: 7, stardate: 42494.8, airDate: DateTime(1989, 1, 30)),
    Episode(id: 'tng_s2_e8', title: 'A Matter of Honor', seasonNumber: 2, episodeNumber: 8, stardate: 42506.5, airDate: DateTime(1989, 2, 6)),
    Episode(id: 'tng_s2_e9', title: 'The Measure of a Man', seasonNumber: 2, episodeNumber: 9, stardate: 42523.7, airDate: DateTime(1989, 2, 13)),
    Episode(id: 'tng_s2_e10', title: 'The Dauphin', seasonNumber: 2, episodeNumber: 10, stardate: 42568.8, airDate: DateTime(1989, 2, 20)),
    Episode(id: 'tng_s2_e11', title: 'Contagion', seasonNumber: 2, episodeNumber: 11, stardate: 42609.1, airDate: DateTime(1989, 3, 20)),
    Episode(id: 'tng_s2_e12', title: 'The Royale', seasonNumber: 2, episodeNumber: 12, stardate: 42625.4, airDate: DateTime(1989, 3, 27)),
    Episode(id: 'tng_s2_e13', title: 'Time Squared', seasonNumber: 2, episodeNumber: 13, stardate: 42679.2, airDate: DateTime(1989, 4, 3)),
    Episode(id: 'tng_s2_e14', title: 'The Icarus Factor', seasonNumber: 2, episodeNumber: 14, stardate: 42686.4, airDate: DateTime(1989, 4, 24)),
    Episode(id: 'tng_s2_e15', title: 'Pen Pals', seasonNumber: 2, episodeNumber: 15, stardate: 42695.3, airDate: DateTime(1989, 5, 1)),
    Episode(id: 'tng_s2_e16', title: 'Q Who', seasonNumber: 2, episodeNumber: 16, stardate: 42761.3, airDate: DateTime(1989, 5, 8)),
    Episode(id: 'tng_s2_e17', title: 'Samaritan Snare', seasonNumber: 2, episodeNumber: 17, stardate: 42779.1, airDate: DateTime(1989, 5, 15)),
    Episode(id: 'tng_s2_e18', title: 'Up the Long Ladder', seasonNumber: 2, episodeNumber: 18, stardate: 42823.2, airDate: DateTime(1989, 5, 22)),
    Episode(id: 'tng_s2_e19', title: 'Manhunt', seasonNumber: 2, episodeNumber: 19, stardate: 42859.2, airDate: DateTime(1989, 6, 19)),
    Episode(id: 'tng_s2_e20', title: 'The Emissary', seasonNumber: 2, episodeNumber: 20, stardate: 42901.3, airDate: DateTime(1989, 6, 29)),
    Episode(id: 'tng_s2_e21', title: 'Peak Performance', seasonNumber: 2, episodeNumber: 21, stardate: 42923.4, airDate: DateTime(1989, 7, 10)),
    Episode(id: 'tng_s2_e22', title: 'Shades of Gray', seasonNumber: 2, episodeNumber: 22, stardate: 42976.1, airDate: DateTime(1989, 7, 17)),
  ];
  
  List<Episode> _getTNGS3Episodes() => [
    Episode(id: 'tng_s3_e1', title: 'Evolution', seasonNumber: 3, episodeNumber: 1, stardate: 43125.8, airDate: DateTime(1989, 9, 25)),
    Episode(id: 'tng_s3_e2', title: 'The Ensigns of Command', seasonNumber: 3, episodeNumber: 2, stardate: 43133.3, airDate: DateTime(1989, 10, 2)),
    Episode(id: 'tng_s3_e3', title: 'The Survivors', seasonNumber: 3, episodeNumber: 3, stardate: 43152.4, airDate: DateTime(1989, 10, 9)),
    Episode(id: 'tng_s3_e4', title: 'Who Watches the Watchers', seasonNumber: 3, episodeNumber: 4, stardate: 43173.5, airDate: DateTime(1989, 10, 16)),
    Episode(id: 'tng_s3_e5', title: 'The Bonding', seasonNumber: 3, episodeNumber: 5, stardate: 43198.7, airDate: DateTime(1989, 10, 23)),
    Episode(id: 'tng_s3_e6', title: 'Booby Trap', seasonNumber: 3, episodeNumber: 6, stardate: 43205.6, airDate: DateTime(1989, 10, 30)),
    Episode(id: 'tng_s3_e7', title: 'The Enemy', seasonNumber: 3, episodeNumber: 7, stardate: 43349.2, airDate: DateTime(1989, 11, 6)),
    Episode(id: 'tng_s3_e8', title: 'The Price', seasonNumber: 3, episodeNumber: 8, stardate: 43385.6, airDate: DateTime(1989, 11, 13)),
    Episode(id: 'tng_s3_e9', title: 'The Vengeance Factor', seasonNumber: 3, episodeNumber: 9, stardate: 43421.9, airDate: DateTime(1989, 11, 20)),
    Episode(id: 'tng_s3_e10', title: 'The Defector', seasonNumber: 3, episodeNumber: 10, stardate: 43462.5, airDate: DateTime(1990, 1, 1)),
    Episode(id: 'tng_s3_e11', title: 'The Hunted', seasonNumber: 3, episodeNumber: 11, stardate: 43489.2, airDate: DateTime(1990, 1, 8)),
    Episode(id: 'tng_s3_e12', title: 'The High Ground', seasonNumber: 3, episodeNumber: 12, stardate: 43510.7, airDate: DateTime(1990, 1, 29)),
    Episode(id: 'tng_s3_e13', title: 'Déjà Q', seasonNumber: 3, episodeNumber: 13, stardate: 43539.1, airDate: DateTime(1990, 2, 5)),
    Episode(id: 'tng_s3_e14', title: 'A Matter of Perspective', seasonNumber: 3, episodeNumber: 14, stardate: 43610.4, airDate: DateTime(1990, 2, 12)),
    Episode(id: 'tng_s3_e15', title: 'Yesterday\'s Enterprise', seasonNumber: 3, episodeNumber: 15, stardate: 43625.2, airDate: DateTime(1990, 2, 19)),
    Episode(id: 'tng_s3_e16', title: 'The Offspring', seasonNumber: 3, episodeNumber: 16, stardate: 43657.0, airDate: DateTime(1990, 3, 12)),
    Episode(id: 'tng_s3_e17', title: 'Sins of the Father', seasonNumber: 3, episodeNumber: 17, stardate: 43685.2, airDate: DateTime(1990, 3, 19)),
    Episode(id: 'tng_s3_e18', title: 'Allegiance', seasonNumber: 3, episodeNumber: 18, stardate: 43714.1, airDate: DateTime(1990, 3, 26)),
    Episode(id: 'tng_s3_e19', title: 'Captain\'s Holiday', seasonNumber: 3, episodeNumber: 19, stardate: 43745.2, airDate: DateTime(1990, 4, 2)),
    Episode(id: 'tng_s3_e20', title: 'Tin Man', seasonNumber: 3, episodeNumber: 20, stardate: 43779.3, airDate: DateTime(1990, 4, 23)),
    Episode(id: 'tng_s3_e21', title: 'Hollow Pursuits', seasonNumber: 3, episodeNumber: 21, stardate: 43807.4, airDate: DateTime(1990, 4, 30)),
    Episode(id: 'tng_s3_e22', title: 'The Most Toys', seasonNumber: 3, episodeNumber: 22, stardate: 43872.2, airDate: DateTime(1990, 5, 7)),
    Episode(id: 'tng_s3_e23', title: 'Sarek', seasonNumber: 3, episodeNumber: 23, stardate: 43917.4, airDate: DateTime(1990, 5, 14)),
    Episode(id: 'tng_s3_e24', title: 'Ménage à Troi', seasonNumber: 3, episodeNumber: 24, stardate: 43930.7, airDate: DateTime(1990, 5, 28)),
    Episode(id: 'tng_s3_e25', title: 'Transfigurations', seasonNumber: 3, episodeNumber: 25, stardate: 43957.2, airDate: DateTime(1990, 6, 4)),
    Episode(id: 'tng_s3_e26', title: 'The Best of Both Worlds', seasonNumber: 3, episodeNumber: 26, stardate: 43989.1, airDate: DateTime(1990, 6, 18)),
  ];
  
  List<Episode> _getTNGS4Episodes() => [
    Episode(id: 'tng_s4_e1', title: 'The Best of Both Worlds, Part II', seasonNumber: 4, episodeNumber: 1, stardate: 44001.4, airDate: DateTime(1990, 9, 24)),
    Episode(id: 'tng_s4_e2', title: 'Family', seasonNumber: 4, episodeNumber: 2, stardate: 44012.3, airDate: DateTime(1990, 10, 1)),
    Episode(id: 'tng_s4_e3', title: 'Brothers', seasonNumber: 4, episodeNumber: 3, stardate: 44085.7, airDate: DateTime(1990, 10, 8)),
    Episode(id: 'tng_s4_e4', title: 'Suddenly Human', seasonNumber: 4, episodeNumber: 4, stardate: 44143.7, airDate: DateTime(1990, 10, 15)),
    Episode(id: 'tng_s4_e5', title: 'Remember Me', seasonNumber: 4, episodeNumber: 5, stardate: 44161.2, airDate: DateTime(1990, 10, 22)),
    Episode(id: 'tng_s4_e6', title: 'Legacy', seasonNumber: 4, episodeNumber: 6, stardate: 44215.2, airDate: DateTime(1990, 10, 29)),
    Episode(id: 'tng_s4_e7', title: 'Reunion', seasonNumber: 4, episodeNumber: 7, stardate: 44246.3, airDate: DateTime(1990, 11, 5)),
    Episode(id: 'tng_s4_e8', title: 'Future Imperfect', seasonNumber: 4, episodeNumber: 8, stardate: 44286.5, airDate: DateTime(1990, 11, 12)),
    Episode(id: 'tng_s4_e9', title: 'Final Mission', seasonNumber: 4, episodeNumber: 9, stardate: 44307.3, airDate: DateTime(1990, 11, 19)),
    Episode(id: 'tng_s4_e10', title: 'The Loss', seasonNumber: 4, episodeNumber: 10, stardate: 44356.9, airDate: DateTime(1990, 12, 31)),
    Episode(id: 'tng_s4_e11', title: 'Data\'s Day', seasonNumber: 4, episodeNumber: 11, stardate: 44390.1, airDate: DateTime(1991, 1, 7)),
    Episode(id: 'tng_s4_e12', title: 'The Wounded', seasonNumber: 4, episodeNumber: 12, stardate: 44429.6, airDate: DateTime(1991, 1, 28)),
    Episode(id: 'tng_s4_e13', title: 'Devil\'s Due', seasonNumber: 4, episodeNumber: 13, stardate: 44474.5, airDate: DateTime(1991, 2, 4)),
    Episode(id: 'tng_s4_e14', title: 'Clues', seasonNumber: 4, episodeNumber: 14, stardate: 44502.7, airDate: DateTime(1991, 2, 11)),
    Episode(id: 'tng_s4_e15', title: 'First Contact', seasonNumber: 4, episodeNumber: 15, stardate: 44429.6, airDate: DateTime(1991, 2, 18)),
    Episode(id: 'tng_s4_e16', title: 'Galaxy\'s Child', seasonNumber: 4, episodeNumber: 16, stardate: 44614.6, airDate: DateTime(1991, 3, 11)),
    Episode(id: 'tng_s4_e17', title: 'Night Terrors', seasonNumber: 4, episodeNumber: 17, stardate: 44631.2, airDate: DateTime(1991, 3, 18)),
    Episode(id: 'tng_s4_e18', title: 'Identity Crisis', seasonNumber: 4, episodeNumber: 18, stardate: 44664.5, airDate: DateTime(1991, 3, 25)),
    Episode(id: 'tng_s4_e19', title: 'The Nth Degree', seasonNumber: 4, episodeNumber: 19, stardate: 44704.2, airDate: DateTime(1991, 4, 1)),
    Episode(id: 'tng_s4_e20', title: 'Qpid', seasonNumber: 4, episodeNumber: 20, stardate: 44741.9, airDate: DateTime(1991, 4, 22)),
    Episode(id: 'tng_s4_e21', title: 'The Drumhead', seasonNumber: 4, episodeNumber: 21, stardate: 44769.2, airDate: DateTime(1991, 4, 29)),
    Episode(id: 'tng_s4_e22', title: 'Half a Life', seasonNumber: 4, episodeNumber: 22, stardate: 44805.3, airDate: DateTime(1991, 5, 6)),
    Episode(id: 'tng_s4_e23', title: 'The Host', seasonNumber: 4, episodeNumber: 23, stardate: 44821.3, airDate: DateTime(1991, 5, 13)),
    Episode(id: 'tng_s4_e24', title: 'The Mind\'s Eye', seasonNumber: 4, episodeNumber: 24, stardate: 44885.5, airDate: DateTime(1991, 5, 27)),
    Episode(id: 'tng_s4_e25', title: 'In Theory', seasonNumber: 4, episodeNumber: 25, stardate: 44932.3, airDate: DateTime(1991, 6, 3)),
    Episode(id: 'tng_s4_e26', title: 'Redemption', seasonNumber: 4, episodeNumber: 26, stardate: 44995.3, airDate: DateTime(1991, 6, 17)),
  ];
  
  List<Episode> _getTNGS5Episodes() => [
    Episode(id: 'tng_s5_e1', title: 'Redemption II', seasonNumber: 5, episodeNumber: 1, stardate: 45020.4, airDate: DateTime(1991, 9, 23)),
    Episode(id: 'tng_s5_e2', title: 'Darmok', seasonNumber: 5, episodeNumber: 2, stardate: 45047.2, airDate: DateTime(1991, 9, 30)),
    Episode(id: 'tng_s5_e3', title: 'Ensign Ro', seasonNumber: 5, episodeNumber: 3, stardate: 45076.3, airDate: DateTime(1991, 10, 7)),
    Episode(id: 'tng_s5_e4', title: 'Silicon Avatar', seasonNumber: 5, episodeNumber: 4, stardate: 45122.3, airDate: DateTime(1991, 10, 14)),
    Episode(id: 'tng_s5_e5', title: 'Disaster', seasonNumber: 5, episodeNumber: 5, stardate: 45156.1, airDate: DateTime(1991, 10, 21)),
    Episode(id: 'tng_s5_e6', title: 'The Game', seasonNumber: 5, episodeNumber: 6, stardate: 45208.2, airDate: DateTime(1991, 10, 28)),
    Episode(id: 'tng_s5_e7', title: 'Unification I', seasonNumber: 5, episodeNumber: 7, stardate: 45236.4, airDate: DateTime(1991, 11, 4)),
    Episode(id: 'tng_s5_e8', title: 'Unification II', seasonNumber: 5, episodeNumber: 8, stardate: 45245.8, airDate: DateTime(1991, 11, 11)),
    Episode(id: 'tng_s5_e9', title: 'A Matter of Time', seasonNumber: 5, episodeNumber: 9, stardate: 45349.1, airDate: DateTime(1991, 11, 18)),
    Episode(id: 'tng_s5_e10', title: 'New Ground', seasonNumber: 5, episodeNumber: 10, stardate: 45376.3, airDate: DateTime(1992, 1, 6)),
    Episode(id: 'tng_s5_e11', title: 'Hero Worship', seasonNumber: 5, episodeNumber: 11, stardate: 45397.3, airDate: DateTime(1992, 1, 27)),
    Episode(id: 'tng_s5_e12', title: 'Violations', seasonNumber: 5, episodeNumber: 12, stardate: 45429.3, airDate: DateTime(1992, 2, 3)),
    Episode(id: 'tng_s5_e13', title: 'The Masterpiece Society', seasonNumber: 5, episodeNumber: 13, stardate: 45470.1, airDate: DateTime(1992, 2, 10)),
    Episode(id: 'tng_s5_e14', title: 'Conundrum', seasonNumber: 5, episodeNumber: 14, stardate: 45494.2, airDate: DateTime(1992, 2, 17)),
    Episode(id: 'tng_s5_e15', title: 'Power Play', seasonNumber: 5, episodeNumber: 15, stardate: 45571.2, airDate: DateTime(1992, 2, 24)),
    Episode(id: 'tng_s5_e16', title: 'Ethics', seasonNumber: 5, episodeNumber: 16, stardate: 45587.3, airDate: DateTime(1992, 3, 2)),
    Episode(id: 'tng_s5_e17', title: 'The Outcast', seasonNumber: 5, episodeNumber: 17, stardate: 45614.6, airDate: DateTime(1992, 3, 16)),
    Episode(id: 'tng_s5_e18', title: 'Cause and Effect', seasonNumber: 5, episodeNumber: 18, stardate: 45652.1, airDate: DateTime(1992, 3, 23)),
    Episode(id: 'tng_s5_e19', title: 'The First Duty', seasonNumber: 5, episodeNumber: 19, stardate: 45703.9, airDate: DateTime(1992, 3, 30)),
    Episode(id: 'tng_s5_e20', title: 'Cost of Living', seasonNumber: 5, episodeNumber: 20, stardate: 45733.6, airDate: DateTime(1992, 4, 20)),
    Episode(id: 'tng_s5_e21', title: 'The Perfect Mate', seasonNumber: 5, episodeNumber: 21, stardate: 45761.3, airDate: DateTime(1992, 4, 27)),
    Episode(id: 'tng_s5_e22', title: 'Imaginary Friend', seasonNumber: 5, episodeNumber: 22, stardate: 45852.1, airDate: DateTime(1992, 5, 4)),
    Episode(id: 'tng_s5_e23', title: 'I Borg', seasonNumber: 5, episodeNumber: 23, stardate: 45854.2, airDate: DateTime(1992, 5, 11)),
    Episode(id: 'tng_s5_e24', title: 'The Next Phase', seasonNumber: 5, episodeNumber: 24, stardate: 45892.4, airDate: DateTime(1992, 5, 18)),
    Episode(id: 'tng_s5_e25', title: 'The Inner Light', seasonNumber: 5, episodeNumber: 25, stardate: 45944.1, airDate: DateTime(1992, 6, 1)),
    Episode(id: 'tng_s5_e26', title: 'Time\'s Arrow', seasonNumber: 5, episodeNumber: 26, stardate: 45959.1, airDate: DateTime(1992, 6, 15)),
  ];
  
  List<Episode> _getTNGS6Episodes() => [
    Episode(id: 'tng_s6_e1', title: 'Time\'s Arrow, Part II', seasonNumber: 6, episodeNumber: 1, stardate: 46001.3, airDate: DateTime(1992, 9, 21)),
    Episode(id: 'tng_s6_e2', title: 'Realm of Fear', seasonNumber: 6, episodeNumber: 2, stardate: 46041.1, airDate: DateTime(1992, 9, 28)),
    Episode(id: 'tng_s6_e3', title: 'Man of the People', seasonNumber: 6, episodeNumber: 3, stardate: 46071.6, airDate: DateTime(1992, 10, 5)),
    Episode(id: 'tng_s6_e4', title: 'Relics', seasonNumber: 6, episodeNumber: 4, stardate: 46125.3, airDate: DateTime(1992, 10, 12)),
    Episode(id: 'tng_s6_e5', title: 'Schisms', seasonNumber: 6, episodeNumber: 5, stardate: 46154.2, airDate: DateTime(1992, 10, 19)),
    Episode(id: 'tng_s6_e6', title: 'True Q', seasonNumber: 6, episodeNumber: 6, stardate: 46192.3, airDate: DateTime(1992, 10, 26)),
    Episode(id: 'tng_s6_e7', title: 'Rascals', seasonNumber: 6, episodeNumber: 7, stardate: 46235.7, airDate: DateTime(1992, 11, 2)),
    Episode(id: 'tng_s6_e8', title: 'A Fistful of Datas', seasonNumber: 6, episodeNumber: 8, stardate: 46271.5, airDate: DateTime(1992, 11, 9)),
    Episode(id: 'tng_s6_e9', title: 'The Quality of Life', seasonNumber: 6, episodeNumber: 9, stardate: 46307.2, airDate: DateTime(1992, 11, 16)),
    Episode(id: 'tng_s6_e10', title: 'Chain of Command, Part I', seasonNumber: 6, episodeNumber: 10, stardate: 46357.4, airDate: DateTime(1992, 12, 14)),
    Episode(id: 'tng_s6_e11', title: 'Chain of Command, Part II', seasonNumber: 6, episodeNumber: 11, stardate: 46360.8, airDate: DateTime(1992, 12, 21)),
    Episode(id: 'tng_s6_e12', title: 'Ship in a Bottle', seasonNumber: 6, episodeNumber: 12, stardate: 46424.1, airDate: DateTime(1993, 1, 25)),
    Episode(id: 'tng_s6_e13', title: 'Aquiel', seasonNumber: 6, episodeNumber: 13, stardate: 46461.3, airDate: DateTime(1993, 2, 1)),
    Episode(id: 'tng_s6_e14', title: 'Face of the Enemy', seasonNumber: 6, episodeNumber: 14, stardate: 46519.1, airDate: DateTime(1993, 2, 8)),
    Episode(id: 'tng_s6_e15', title: 'Tapestry', seasonNumber: 6, episodeNumber: 15, stardate: 0.0, airDate: DateTime(1993, 2, 15)),
    Episode(id: 'tng_s6_e16', title: 'Birthright, Part I', seasonNumber: 6, episodeNumber: 16, stardate: 46578.4, airDate: DateTime(1993, 2, 22)),
    Episode(id: 'tng_s6_e17', title: 'Birthright, Part II', seasonNumber: 6, episodeNumber: 17, stardate: 46759.2, airDate: DateTime(1993, 3, 1)),
    Episode(id: 'tng_s6_e18', title: 'Starship Mine', seasonNumber: 6, episodeNumber: 18, stardate: 46682.4, airDate: DateTime(1993, 3, 29)),
    Episode(id: 'tng_s6_e19', title: 'Lessons', seasonNumber: 6, episodeNumber: 19, stardate: 46693.1, airDate: DateTime(1993, 4, 5)),
    Episode(id: 'tng_s6_e20', title: 'The Chase', seasonNumber: 6, episodeNumber: 20, stardate: 46731.5, airDate: DateTime(1993, 4, 26)),
    Episode(id: 'tng_s6_e21', title: 'Frame of Mind', seasonNumber: 6, episodeNumber: 21, stardate: 46778.1, airDate: DateTime(1993, 5, 3)),
    Episode(id: 'tng_s6_e22', title: 'Suspicions', seasonNumber: 6, episodeNumber: 22, stardate: 46830.1, airDate: DateTime(1993, 5, 10)),
    Episode(id: 'tng_s6_e23', title: 'Rightful Heir', seasonNumber: 6, episodeNumber: 23, stardate: 46852.2, airDate: DateTime(1993, 5, 17)),
    Episode(id: 'tng_s6_e24', title: 'Second Chances', seasonNumber: 6, episodeNumber: 24, stardate: 46915.2, airDate: DateTime(1993, 5, 24)),
    Episode(id: 'tng_s6_e25', title: 'Timescape', seasonNumber: 6, episodeNumber: 25, stardate: 46944.2, airDate: DateTime(1993, 6, 14)),
    Episode(id: 'tng_s6_e26', title: 'Descent', seasonNumber: 6, episodeNumber: 26, stardate: 46982.1, airDate: DateTime(1993, 6, 21)),
  ];
  
  List<Episode> _getTNGS7Episodes() => [
    Episode(id: 'tng_s7_e1', title: 'Descent, Part II', seasonNumber: 7, episodeNumber: 1, stardate: 47025.4, airDate: DateTime(1993, 9, 20)),
    Episode(id: 'tng_s7_e2', title: 'Liaisons', seasonNumber: 7, episodeNumber: 2, stardate: 47254.1, airDate: DateTime(1993, 9, 27)),
    Episode(id: 'tng_s7_e3', title: 'Interface', seasonNumber: 7, episodeNumber: 3, stardate: 47215.5, airDate: DateTime(1993, 10, 4)),
    Episode(id: 'tng_s7_e4', title: 'Gambit, Part I', seasonNumber: 7, episodeNumber: 4, stardate: 47135.2, airDate: DateTime(1993, 10, 11)),
    Episode(id: 'tng_s7_e5', title: 'Gambit, Part II', seasonNumber: 7, episodeNumber: 5, stardate: 47160.1, airDate: DateTime(1993, 10, 18)),
    Episode(id: 'tng_s7_e6', title: 'Phantasms', seasonNumber: 7, episodeNumber: 6, stardate: 47225.7, airDate: DateTime(1993, 10, 25)),
    Episode(id: 'tng_s7_e7', title: 'Dark Page', seasonNumber: 7, episodeNumber: 7, stardate: 47254.1, airDate: DateTime(1993, 11, 1)),
    Episode(id: 'tng_s7_e8', title: 'Attached', seasonNumber: 7, episodeNumber: 8, stardate: 47304.2, airDate: DateTime(1993, 11, 8)),
    Episode(id: 'tng_s7_e9', title: 'Force of Nature', seasonNumber: 7, episodeNumber: 9, stardate: 47310.2, airDate: DateTime(1993, 11, 15)),
    Episode(id: 'tng_s7_e10', title: 'Inheritance', seasonNumber: 7, episodeNumber: 10, stardate: 47410.2, airDate: DateTime(1993, 11, 22)),
    Episode(id: 'tng_s7_e11', title: 'Parallels', seasonNumber: 7, episodeNumber: 11, stardate: 47391.2, airDate: DateTime(1993, 11, 29)),
    Episode(id: 'tng_s7_e12', title: 'The Pegasus', seasonNumber: 7, episodeNumber: 12, stardate: 47457.1, airDate: DateTime(1994, 1, 10)),
    Episode(id: 'tng_s7_e13', title: 'Homeward', seasonNumber: 7, episodeNumber: 13, stardate: 47423.9, airDate: DateTime(1994, 1, 17)),
    Episode(id: 'tng_s7_e14', title: 'Sub Rosa', seasonNumber: 7, episodeNumber: 14, stardate: 47423.9, airDate: DateTime(1994, 1, 31)),
    Episode(id: 'tng_s7_e15', title: 'Lower Decks', seasonNumber: 7, episodeNumber: 15, stardate: 47566.7, airDate: DateTime(1994, 2, 7)),
    Episode(id: 'tng_s7_e16', title: 'Thine Own Self', seasonNumber: 7, episodeNumber: 16, stardate: 47611.2, airDate: DateTime(1994, 2, 14)),
    Episode(id: 'tng_s7_e17', title: 'Masks', seasonNumber: 7, episodeNumber: 17, stardate: 47615.2, airDate: DateTime(1994, 2, 21)),
    Episode(id: 'tng_s7_e18', title: 'Eye of the Beholder', seasonNumber: 7, episodeNumber: 18, stardate: 47622.1, airDate: DateTime(1994, 2, 28)),
    Episode(id: 'tng_s7_e19', title: 'Genesis', seasonNumber: 7, episodeNumber: 19, stardate: 47653.2, airDate: DateTime(1994, 3, 21)),
    Episode(id: 'tng_s7_e20', title: 'Journey\'s End', seasonNumber: 7, episodeNumber: 20, stardate: 47751.2, airDate: DateTime(1994, 3, 28)),
    Episode(id: 'tng_s7_e21', title: 'Firstborn', seasonNumber: 7, episodeNumber: 21, stardate: 47779.4, airDate: DateTime(1994, 4, 25)),
    Episode(id: 'tng_s7_e22', title: 'Bloodlines', seasonNumber: 7, episodeNumber: 22, stardate: 47829.1, airDate: DateTime(1994, 5, 2)),
    Episode(id: 'tng_s7_e23', title: 'Emergence', seasonNumber: 7, episodeNumber: 23, stardate: 47869.2, airDate: DateTime(1994, 5, 9)),
    Episode(id: 'tng_s7_e24', title: 'Preemptive Strike', seasonNumber: 7, episodeNumber: 24, stardate: 47941.7, airDate: DateTime(1994, 5, 16)),
    Episode(id: 'tng_s7_e25', title: 'All Good Things...', seasonNumber: 7, episodeNumber: 25, stardate: 47988.0, airDate: DateTime(1994, 5, 23)),
  ];

  List<Episode> _getDS9S1Episodes() => [
    Episode(id: 'ds9_s1_e1', title: 'Emissary', seasonNumber: 1, episodeNumber: 1, stardate: 46379.1, airDate: DateTime(1993, 1, 3)),
    Episode(id: 'ds9_s1_e2', title: 'A Man Alone', seasonNumber: 1, episodeNumber: 2, stardate: 46421.5, airDate: DateTime(1993, 1, 17)),
    Episode(id: 'ds9_s1_e3', title: 'Past Prologue', seasonNumber: 1, episodeNumber: 3, stardate: 46910.1, airDate: DateTime(1993, 1, 10)),
    Episode(id: 'ds9_s1_e4', title: 'Babel', seasonNumber: 1, episodeNumber: 4, stardate: 46423.7, airDate: DateTime(1993, 1, 24)),
    Episode(id: 'ds9_s1_e5', title: 'Captive Pursuit', seasonNumber: 1, episodeNumber: 5, stardate: 46475.1, airDate: DateTime(1993, 1, 31)),
    Episode(id: 'ds9_s1_e6', title: 'Q-Less', seasonNumber: 1, episodeNumber: 6, stardate: 46531.2, airDate: DateTime(1993, 2, 7)),
    Episode(id: 'ds9_s1_e7', title: 'Dax', seasonNumber: 1, episodeNumber: 7, stardate: 46910.1, airDate: DateTime(1993, 2, 14)),
    Episode(id: 'ds9_s1_e8', title: 'The Passenger', seasonNumber: 1, episodeNumber: 8, stardate: 46579.2, airDate: DateTime(1993, 2, 21)),
    Episode(id: 'ds9_s1_e9', title: 'Move Along Home', seasonNumber: 1, episodeNumber: 9, stardate: 46611.2, airDate: DateTime(1993, 3, 14)),
    Episode(id: 'ds9_s1_e10', title: 'The Nagus', seasonNumber: 1, episodeNumber: 10, stardate: 46910.1, airDate: DateTime(1993, 3, 21)),
    Episode(id: 'ds9_s1_e11', title: 'Vortex', seasonNumber: 1, episodeNumber: 11, stardate: 46910.1, airDate: DateTime(1993, 4, 18)),
    Episode(id: 'ds9_s1_e12', title: 'Battle Lines', seasonNumber: 1, episodeNumber: 12, stardate: 46922.3, airDate: DateTime(1993, 4, 25)),
    Episode(id: 'ds9_s1_e13', title: 'The Storyteller', seasonNumber: 1, episodeNumber: 13, stardate: 46729.1, airDate: DateTime(1993, 5, 2)),
    Episode(id: 'ds9_s1_e14', title: 'Progress', seasonNumber: 1, episodeNumber: 14, stardate: 46844.3, airDate: DateTime(1993, 5, 9)),
    Episode(id: 'ds9_s1_e15', title: 'If Wishes Were Horses', seasonNumber: 1, episodeNumber: 15, stardate: 46853.2, airDate: DateTime(1993, 5, 16)),
    Episode(id: 'ds9_s1_e16', title: 'The Forsaken', seasonNumber: 1, episodeNumber: 16, stardate: 46925.1, airDate: DateTime(1993, 5, 23)),
    Episode(id: 'ds9_s1_e17', title: 'Dramatis Personae', seasonNumber: 1, episodeNumber: 17, stardate: 46922.3, airDate: DateTime(1993, 5, 30)),
    Episode(id: 'ds9_s1_e18', title: 'Duet', seasonNumber: 1, episodeNumber: 18, stardate: 46910.1, airDate: DateTime(1993, 6, 13)),
    Episode(id: 'ds9_s1_e19', title: 'In the Hands of the Prophets', seasonNumber: 1, episodeNumber: 19, stardate: 46910.1, airDate: DateTime(1993, 6, 20)),
  ];
  
  List<Episode> _getDS9S2Episodes() => _generateEpisodes('ds9', 2, [
    'The Homecoming', 'The Circle', 'The Siege', 'Invasive Procedures', 'Cardassians',
    'Melora', 'Rules of Acquisition', 'Necessary Evil', 'Second Sight', 'Sanctuary',
    'Rivals', 'The Alternate', 'Armageddon Game', 'Whispers', 'Paradise',
    'Shadowplay', 'Playing God', 'Profit and Loss', 'Blood Oath', 'The Maquis, Part I',
    'The Maquis, Part II', 'The Wire', 'Crossover', 'The Collaborator', 'Tribunal',
    'The Jem\'Hadar'
  ]);
  
  List<Episode> _getDS9S3Episodes() => _generateEpisodes('ds9', 3, [
    'The Search, Part I', 'The Search, Part II', 'The House of Quark', 'Equilibrium', 'Second Skin',
    'The Abandoned', 'Civil Defense', 'Meridian', 'Defiant', 'Fascination',
    'Past Tense, Part I', 'Past Tense, Part II', 'Life Support', 'Heart of Stone', 'Destiny',
    'Prophet Motive', 'Visionary', 'Distant Voices', 'Through the Looking Glass', 'Improbable Cause',
    'The Die Is Cast', 'Explorers', 'Family Business', 'Shakaar', 'Facets',
    'The Adversary'
  ]);
  
  List<Episode> _getDS9S4Episodes() => _generateEpisodes('ds9', 4, [
    'The Way of the Warrior', 'The Visitor', 'Hippocratic Oath', 'Indiscretion', 'Rejoined',
    'Starship Down', 'Little Green Men', 'The Sword of Kahless', 'Our Man Bashir', 'Homefront',
    'Paradise Lost', 'Crossfire', 'Return to Grace', 'Sons of Mogh', 'Bar Association',
    'Accession', 'Rules of Engagement', 'Hard Time', 'Shattered Mirror', 'The Muse',
    'For the Cause', 'To the Death', 'The Quickening', 'Body Parts', 'Broken Link'
  ]);
  
  List<Episode> _getDS9S5Episodes() => _generateEpisodes('ds9', 5, [
    'Apocalypse Rising', 'The Ship', 'Looking for par\'Mach in All the Wrong Places', 'Nor the Battle to the Strong', 'The Assignment',
    'Trials and Tribble-ations', 'Let He Who Is Without Sin...', 'Things Past', 'The Ascent', 'Rapture',
    'The Darkness and the Light', 'The Begotten', 'For the Uniform', 'In Purgatory\'s Shadow', 'By Inferno\'s Light',
    'Doctor Bashir, I Presume', 'A Simple Investigation', 'Business as Usual', 'Ties of Blood and Water', 'Ferengi Love Songs',
    'Soldiers of the Empire', 'Children of Time', 'Blaze of Glory', 'Empok Nor', 'In the Cards',
    'Call to Arms'
  ]);
  
  List<Episode> _getDS9S6Episodes() => _generateEpisodes('ds9', 6, [
    'A Time to Stand', 'Rocks and Shoals', 'Sons and Daughters', 'Behind the Lines', 'Favor the Bold',
    'Sacrifice of Angels', 'You Are Cordially Invited', 'Resurrection', 'Statistical Probabilities', 'The Magnificent Ferengi',
    'Waltz', 'Who Mourns for Morn?', 'Far Beyond the Stars', 'One Little Ship', 'Honor Among Thieves',
    'Change of Heart', 'Wrongs Darker Than Death or Night', 'Inquisition', 'In the Pale Moonlight', 'His Way',
    'The Reckoning', 'Valiant', 'Profit and Lace', 'Time\'s Orphan', 'The Sound of Her Voice',
    'Tears of the Prophets'
  ]);
  
  List<Episode> _getDS9S7Episodes() => _generateEpisodes('ds9', 7, [
    'Image in the Sand', 'Shadows and Symbols', 'Afterimage', 'Take Me Out to the Holosuite', 'Chrysalis',
    'Treachery, Faith and the Great River', 'Once More Unto the Breach', 'The Siege of AR-558', 'Covenant', 'It\'s Only a Paper Moon',
    'Prodigal Daughter', 'The Emperor\'s New Cloak', 'Field of Fire', 'Chimera', 'Badda-Bing, Badda-Bang',
    'Inter Arma Enim Silent Leges', 'Penumbra', 'Til Death Do Us Part', 'Strange Bedfellows', 'The Changing Face of Evil',
    'When It Rains...', 'Tacking Into the Wind', 'Extreme Measures', 'The Dogs of War', 'What You Leave Behind'
  ]);

  List<Episode> _getVoyagerS1Episodes() => [
    Episode(id: 'voy_s1_e1', title: 'Caretaker', seasonNumber: 1, episodeNumber: 1, stardate: 48315.6, airDate: DateTime(1995, 1, 16)),
    Episode(id: 'voy_s1_e2', title: 'Parallax', seasonNumber: 1, episodeNumber: 2, stardate: 48439.7, airDate: DateTime(1995, 1, 23)),
    Episode(id: 'voy_s1_e3', title: 'Time and Again', seasonNumber: 1, episodeNumber: 3, airDate: DateTime(1995, 1, 30)),
    Episode(id: 'voy_s1_e4', title: 'Phage', seasonNumber: 1, episodeNumber: 4, stardate: 48532.4, airDate: DateTime(1995, 2, 6)),
    Episode(id: 'voy_s1_e5', title: 'The Cloud', seasonNumber: 1, episodeNumber: 5, stardate: 48546.2, airDate: DateTime(1995, 2, 13)),
    Episode(id: 'voy_s1_e6', title: 'Eye of the Needle', seasonNumber: 1, episodeNumber: 6, stardate: 48579.4, airDate: DateTime(1995, 2, 20)),
    Episode(id: 'voy_s1_e7', title: 'Ex Post Facto', seasonNumber: 1, episodeNumber: 7, airDate: DateTime(1995, 2, 27)),
    Episode(id: 'voy_s1_e8', title: 'Emanations', seasonNumber: 1, episodeNumber: 8, stardate: 48623.5, airDate: DateTime(1995, 3, 13)),
    Episode(id: 'voy_s1_e9', title: 'Prime Factors', seasonNumber: 1, episodeNumber: 9, stardate: 48642.5, airDate: DateTime(1995, 3, 20)),
    Episode(id: 'voy_s1_e10', title: 'State of Flux', seasonNumber: 1, episodeNumber: 10, stardate: 48658.2, airDate: DateTime(1995, 4, 10)),
    Episode(id: 'voy_s1_e11', title: 'Heroes and Demons', seasonNumber: 1, episodeNumber: 11, stardate: 48693.2, airDate: DateTime(1995, 4, 24)),
    Episode(id: 'voy_s1_e12', title: 'Cathexis', seasonNumber: 1, episodeNumber: 12, stardate: 48734.2, airDate: DateTime(1995, 5, 1)),
    Episode(id: 'voy_s1_e13', title: 'Faces', seasonNumber: 1, episodeNumber: 13, stardate: 48784.2, airDate: DateTime(1995, 5, 8)),
    Episode(id: 'voy_s1_e14', title: 'Jetrel', seasonNumber: 1, episodeNumber: 14, stardate: 48832.1, airDate: DateTime(1995, 5, 15)),
    Episode(id: 'voy_s1_e15', title: 'Learning Curve', seasonNumber: 1, episodeNumber: 15, stardate: 48846.5, airDate: DateTime(1995, 5, 22)),
  ];
  
  List<Episode> _getVoyagerS2Episodes() => _generateEpisodes('voy', 2, [
    'The 37\'s', 'Initiations', 'Projections', 'Elogium', 'Non Sequitur',
    'Twisted', 'Parturition', 'Persistence of Vision', 'Tattoo', 'Cold Fire',
    'Maneuvers', 'Resistance', 'Prototype', 'Alliances', 'Threshold',
    'Meld', 'Dreadnought', 'Death Wish', 'Lifesigns', 'Investigations',
    'Deadlock', 'Innocence', 'The Thaw', 'Tuvix', 'Resolutions',
    'Basics, Part I'
  ]);
  
  List<Episode> _getVoyagerS3Episodes() => _generateEpisodes('voy', 3, [
    'Basics, Part II', 'Flashback', 'The Chute', 'The Swarm', 'False Profits',
    'Remember', 'Sacred Ground', 'Future\'s End, Part I', 'Future\'s End, Part II', 'Warlord',
    'The Q and the Grey', 'Macrocosm', 'Fair Trade', 'Alter Ego', 'Coda',
    'Blood Fever', 'Unity', 'Darkling', 'Rise', 'Favorite Son',
    'Before and After', 'Real Life', 'Distant Origin', 'Displaced', 'Worst Case Scenario',
    'Scorpion, Part I'
  ]);
  
  List<Episode> _getVoyagerS4Episodes() => _generateEpisodes('voy', 4, [
    'Scorpion, Part II', 'The Gift', 'Day of Honor', 'Nemesis', 'Revulsion',
    'The Raven', 'Scientific Method', 'Year of Hell, Part I', 'Year of Hell, Part II', 'Random Thoughts',
    'Concerning Flight', 'Mortal Coil', 'Waking Moments', 'Message in a Bottle', 'Hunters',
    'Prey', 'Retrospect', 'The Killing Game, Part I', 'The Killing Game, Part II', 'Vis à Vis',
    'The Omega Directive', 'Unforgotten', 'Living Witness', 'Demon', 'One',
    'Hope and Fear'
  ]);
  
  List<Episode> _getVoyagerS5Episodes() => _generateEpisodes('voy', 5, [
    'Night', 'Drone', 'Extreme Risk', 'In the Flesh', 'Once Upon a Time',
    'Timeless', 'Infinite Regress', 'Nothing Human', 'Thirty Days', 'Counterpoint',
    'Latent Image', 'Bride of Chaotica!', 'Gravity', 'Bliss', 'Dark Frontier, Part I',
    'Dark Frontier, Part II', 'The Disease', 'Course: Oblivion', 'The Fight', 'Think Tank',
    'Juggernaut', 'Someone to Watch Over Me', 'Relativity', '11:59', 'Warhead',
    'Equinox, Part I'
  ]);
  
  List<Episode> _getVoyagerS6Episodes() => _generateEpisodes('voy', 6, [
    'Equinox, Part II', 'Survival Instinct', 'Barge of the Dead', 'Tinker Tenor Doctor Spy', 'Alice',
    'Riddles', 'Dragon\'s Teeth', 'One Small Step', 'The Voyager Conspiracy', 'Pathfinder',
    'Fair Haven', 'Blink of an Eye', 'Virtuoso', 'Memorial', 'Tsunkatse',
    'Collective', 'Spirit Folk', 'Ashes to Ashes', 'Child\'s Play', 'Good Shepherd',
    'Live Fast and Prosper', 'Muse', 'Fury', 'Life Line', 'The Haunting of Deck Twelve',
    'Unimatrix Zero, Part I'
  ]);
  
  List<Episode> _getVoyagerS7Episodes() => _generateEpisodes('voy', 7, [
    'Unimatrix Zero, Part II', 'Imperfection', 'Critical Care', 'Inside Man', 'Body and Soul',
    'Nightingale', 'Flesh and Blood, Part I', 'Flesh and Blood, Part II', 'Shattered', 'Lineage',
    'Repentance', 'The Void', 'Workforce, Part I', 'Workforce, Part II', 'Human Error',
    'Q2', 'Author, Author', 'Friendship One', 'Natural Law', 'Homestead',
    'Renaissance Man', 'Endgame, Part I', 'Endgame, Part II'
  ]);

  List<Episode> _getLowerDecksS1Episodes() => _generateEpisodes('ld', 1, [
    'Second Contact', 'Envoys', 'Temporal Edict', 'Moist Vessel', 'Cupid\'s Errant Arrow',
    'Terminal Provocations', 'Much Ado About Boimler', 'Veritas', 'Crisis Point', 'No Small Parts'
  ]);
  
  List<Episode> _getLowerDecksS2Episodes() => _generateEpisodes('ld', 2, [
    'Strange Energies', 'Kayshon, His Eyes Open', 'We\'ll Always Have Tom Paris', 'Mugato, Gumato', 'An Embarrassment of Dooplers',
    'The Spy Humongous', 'Where Pleasant Fountains Lie', 'I, Excretus', 'wej Duj', 'First First Contact'
  ]);
  
  List<Episode> _getLowerDecksS3Episodes() => _generateEpisodes('ld', 3, [
    'Grounded', 'The Least Dangerous Game', 'Mining the Mind\'s Mines', 'Room for Growth', 'Reflections',
    'Hear All, Trust Nothing', 'A Mathematically Perfect Redemption', 'Crisis Point 2: Paradoxus', 'Trusted Sources', 'The Stars at Night'
  ]);
  
  List<Episode> _getLowerDecksS4Episodes() => _generateEpisodes('ld', 4, [
    'Twovix', 'I Have No Bones Yet I Must Flee', 'In the Cradle of Vexilon', 'Something Borrowed, Something Green', 'Empathological Fallacies',
    'Parth Ferengi\'s Heart Place', 'A Few Badgeys More', 'Caves', 'The Inner Fight', 'Old Friends, New Planets'
  ]);

  List<Episode> _getProdigyS1Episodes() => _generateEpisodes('pro', 1, [
    'Lost and Found', 'Starstruck', 'Dream Catcher', 'Terror Firma', 'Kobayashi',
    'First Con-tact', 'Time Amok', 'A Moral Star', 'Asylum', 'Let Sleeping Borg Lie',
    'All the World\'s a Stage', 'Crossroads', 'Masquerade', 'Preludes', 'Ghost in the Machine',
    'Mindwalk', 'Supernova, Part 1', 'Supernova, Part 2'
  ]);
  
  List<Episode> _getProdigyS2Episodes() => _generateEpisodes('pro', 2, [
    'Into the Breach, Part I', 'Into the Breach, Part II', 'Who Saves the Saviors', 'Temporal Mechanics 101', 'Observer\'s Paradox',
    'Imposter Syndrome', 'The Fast and the Curious', 'Is There in Beauty No Truth?', 'The Devourer of All Things, Part I', 'The Devourer of All Things, Part II',
    'Last Flight of the Protostar, Part I', 'Last Flight of the Protostar, Part II', 'A Tribble Called Quest', 'Cracked Mirror', 'Ascension, Part I',
    'Ascension, Part II', 'Brink', 'Touch of Grey', 'Ouroboros, Part I', 'Ouroboros, Part II'
  ]);

  List<Episode> _getPicardS1Episodes() => _generateEpisodes('pic', 1, [
    'Remembrance', 'Maps and Legends', 'The End Is the Beginning', 'Absolute Candor', 'Stardust City Rag',
    'The Impossible Box', 'Nepenthe', 'Broken Pieces', 'Et in Arcadia Ego, Part 1', 'Et in Arcadia Ego, Part 2'
  ]);
  
  List<Episode> _getPicardS2Episodes() => _generateEpisodes('pic', 2, [
    'The Star Gazer', 'Penance', 'Assimilation', 'Watcher', 'Fly Me to the Moon',
    'Two of One', 'Monsters', 'Mercy', 'Hide and Seek', 'Farewell'
  ]);
  
  List<Episode> _getPicardS3Episodes() => _generateEpisodes('pic', 3, [
    'The Next Generation', 'Disengage', 'Seventeen Seconds', 'No Win Scenario', 'Imposters',
    'The Bounty', 'Dominion', 'Surrender', 'Võx', 'The Last Generation'
  ]);
}