import '../models/star_trek_models.dart';

class MovieService {
  static List<Movie> getStarTrekMovies() {
    return [
      // TOS Era Movies
      Movie(
        id: 'tmp',
        title: 'Star Trek: The Motion Picture',
        stardate: 7412.6,
        releaseDate: DateTime(1979, 12, 7),
        description: 'Set in 2273, after TOS',
        summary:
            'Admiral Kirk reunites with the Enterprise crew to face a mysterious alien entity.',
      ),

      Movie(
        id: 'twok',
        title: 'Star Trek II: The Wrath of Khan',
        stardate: 8130.3,
        releaseDate: DateTime(1982, 6, 4),
        description: 'Set in 2285',
        summary:
            'Kirk faces his old nemesis Khan Noonien Singh in a battle of wits and starships.',
      ),

      Movie(
        id: 'tsfs',
        title: 'Star Trek III: The Search for Spock',
        stardate: 8210.3,
        releaseDate: DateTime(1984, 6, 1),
        description: 'Set in 2285, immediately after Wrath of Khan',
        summary:
            'Kirk and crew steal the Enterprise to retrieve Spock\'s body from the Genesis Planet.',
      ),

      Movie(
        id: 'tvh',
        title: 'Star Trek IV: The Voyage Home',
        stardate: 8390.0,
        releaseDate: DateTime(1986, 11, 26),
        description: 'Set in 2286',
        summary:
            'The crew travels back to 1986 to save humpback whales and Earth\'s future.',
      ),

      Movie(
        id: 'tff',
        title: 'Star Trek V: The Final Frontier',
        stardate: 8454.1,
        releaseDate: DateTime(1989, 6, 9),
        description: 'Set in 2287',
        summary:
            'Spock\'s half-brother Sybok hijacks the Enterprise in search of God.',
      ),

      Movie(
        id: 'tuc',
        title: 'Star Trek VI: The Undiscovered Country',
        stardate: 9521.6,
        releaseDate: DateTime(1991, 12, 6),
        description: 'Set in 2293',
        summary:
            'Kirk and McCoy are framed for assassination as the Federation and Klingons pursue peace.',
      ),

      // TNG Era Movies
      Movie(
        id: 'gen',
        title: 'Star Trek Generations',
        stardate: 48632.4,
        releaseDate: DateTime(1994, 11, 18),
        description: 'Set in 2371, bridges TOS and TNG crews',
        summary:
            'Picard teams up with Kirk to stop Dr. Soran from destroying star systems.',
      ),

      Movie(
        id: 'fc',
        title: 'Star Trek: First Contact',
        stardate: 50893.5,
        releaseDate: DateTime(1996, 11, 22),
        description: 'Set in 2373',
        summary:
            'The Enterprise-E crew travels back to 2063 to stop the Borg from preventing first contact.',
      ),

      Movie(
        id: 'ins',
        title: 'Star Trek: Insurrection',
        stardate: 52561.3,
        releaseDate: DateTime(1998, 12, 11),
        description: 'Set in 2375',
        summary:
            'Picard defies Starfleet orders to protect the Ba\'ku from forced relocation.',
      ),

      Movie(
        id: 'nem',
        title: 'Star Trek: Nemesis',
        stardate: 56844.9,
        releaseDate: DateTime(2002, 12, 13),
        description: 'Set in 2379',
        summary:
            'The Enterprise crew faces Shinzon, a clone of Picard, and his Reman allies.',
      ),

      Movie(
        id: 'sec31',
        title: 'Star Trek: Section 31',
        stardate: 1292.4,
        releaseDate: DateTime(2025, 1, 24),
        description: 'Set in 2324 (Early 24th Century)',
        summary:
            'Emperor Philippa Georgiou from the mirror universe joins the black-ops group Section 31.',
      ),

      // Kelvin Timeline Movies
      Movie(
        id: 'st09',
        title: 'Star Trek (2009)',
        stardate: 2233.04,
        releaseDate: DateTime(2009, 5, 8),
        description: 'Alternate timeline created in 2233',
        summary:
            'Young Kirk and Spock meet in an alternate timeline created by time travel.',
      ),

      Movie(
        id: 'stid',
        title: 'Star Trek Into Darkness',
        stardate: 2259.55,
        releaseDate: DateTime(2013, 5, 16),
        description: 'Set in 2259 (Kelvin Timeline)',
        summary:
            'Kirk and crew face John Harrison, who is revealed to be Khan Noonien Singh.',
      ),

      Movie(
        id: 'stb',
        title: 'Star Trek Beyond',
        stardate: 2263.02,
        releaseDate: DateTime(2016, 7, 22),
        description: 'Set in 2263 (Kelvin Timeline)',
        summary:
            'The Enterprise crew is stranded on an alien planet and must stop Krall\'s revenge plot.',
      ),
    ];
  }

  // Get movies organized by timeline placement
  static Map<String, List<Movie>> getMoviesByTimeline() {
    final movies = getStarTrekMovies();
    final Map<String, List<Movie>> organized = {
      'TOS Era (Prime Timeline)': [],
      'Early 24th Century (Prime Timeline)': [],
      'TNG Era (Prime Timeline)': [],
      'Kelvin Timeline': [],
    };

    for (final movie in movies) {
      if (movie.id == 'st09' || movie.id == 'stid' || movie.id == 'stb') {
        organized['Kelvin Timeline']!.add(movie);
      } else if (movie.id == 'sec31') {
        // Section 31 is specifically early 24th century despite lower stardate
        organized['Early 24th Century (Prime Timeline)']!.add(movie);
      } else if (movie.stardate != null && movie.stardate! < 10000) {
        organized['TOS Era (Prime Timeline)']!.add(movie);
      } else if (movie.stardate != null && movie.stardate! < 40000) {
        organized['Early 24th Century (Prime Timeline)']!.add(movie);
      } else {
        organized['TNG Era (Prime Timeline)']!.add(movie);
      }
    }

    // Sort each category by stardate
    for (final category in organized.keys) {
      organized[category]!.sort((a, b) {
        if (a.stardate == null && b.stardate == null) return 0;
        if (a.stardate == null) return 1;
        if (b.stardate == null) return -1;
        return a.stardate!.compareTo(b.stardate!);
      });
    }

    return organized;
  }

  // Get chronological placement for a movie
  static String getMoviePlacement(Movie movie) {
    if (movie.stardate == null) return 'Unknown timeline placement';

    final stardate = movie.stardate!;

    if (stardate < 3000) {
      return 'Between TOS and TMP';
    } else if (stardate < 10000) {
      return 'TOS Movie Era';
    } else if (stardate < 40000) {
      return 'Early 24th Century';
    } else if (stardate < 50000) {
      return 'TNG Era';
    } else if (stardate < 60000) {
      return 'Post-TNG Era';
    } else {
      return 'Late 24th Century';
    }
  }
}
