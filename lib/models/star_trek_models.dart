class Episode {
  final String id;
  final String title;
  final int seasonNumber;
  final int episodeNumber;
  final double? stardate;
  final DateTime? airDate;
  final String? description;
  final String? summary;
  final int? productionSerialNumber;
  bool isWatched;
  bool isFavorite;
  DateTime? watchedDate;

  Episode({
    required this.id,
    required this.title,
    required this.seasonNumber,
    required this.episodeNumber,
    this.stardate,
    this.airDate,
    this.description,
    this.summary,
    this.productionSerialNumber,
    this.isWatched = false,
    this.isFavorite = false,
    this.watchedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'seasonNumber': seasonNumber,
    'episodeNumber': episodeNumber,
    'stardate': stardate,
    'airDate': airDate?.toIso8601String(),
    'description': description,
    'summary': summary,
    'productionSerialNumber': productionSerialNumber,
    'isWatched': isWatched,
    'isFavorite': isFavorite,
    'watchedDate': watchedDate?.toIso8601String(),
  };

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json['id'],
    title: json['title'],
    seasonNumber: json['seasonNumber'],
    episodeNumber: json['episodeNumber'],
    stardate: json['stardate']?.toDouble(),
    airDate: json['airDate'] != null ? DateTime.parse(json['airDate']) : null,
    description: json['description'],
    summary: json['summary'],
    productionSerialNumber: json['productionSerialNumber'],
    isWatched: json['isWatched'] ?? false,
    isFavorite: json['isFavorite'] ?? false,
    watchedDate: json['watchedDate'] != null ? DateTime.parse(json['watchedDate']) : null,
  );
}

class Season {
  final int number;
  final List<Episode> episodes;

  Season({
    required this.number,
    required this.episodes,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'episodes': episodes.map((e) => e.toJson()).toList(),
  };

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    number: json['number'],
    episodes: (json['episodes'] as List).map((e) => Episode.fromJson(e)).toList(),
  );
}

class Movie {
  final String id;
  final String title;
  final double? stardate;
  final DateTime? releaseDate;
  final String? description;
  final String? summary;
  bool isWatched;
  bool isFavorite;
  DateTime? watchedDate;

  Movie({
    required this.id,
    required this.title,
    this.stardate,
    this.releaseDate,
    this.description,
    this.summary,
    this.isWatched = false,
    this.isFavorite = false,
    this.watchedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'stardate': stardate,
    'releaseDate': releaseDate?.toIso8601String(),
    'description': description,
    'summary': summary,
    'isWatched': isWatched,
    'isFavorite': isFavorite,
    'watchedDate': watchedDate?.toIso8601String(),
  };

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'],
    title: json['title'],
    stardate: json['stardate']?.toDouble(),
    releaseDate: json['releaseDate'] != null ? DateTime.parse(json['releaseDate']) : null,
    description: json['description'],
    summary: json['summary'],
    isWatched: json['isWatched'] ?? false,
    isFavorite: json['isFavorite'] ?? false,
    watchedDate: json['watchedDate'] != null ? DateTime.parse(json['watchedDate']) : null,
  );
}

// Unified chronological item that can be either an episode or movie
abstract class ChronologicalItem {
  String get id;
  String get title;
  double? get stardate;
  DateTime? get airDate;
  bool get isWatched;
  bool get isFavorite;
  DateTime? get watchedDate;
  String get type; // 'episode' or 'movie'
  
  // Get the date to use for chronological sorting
  DateTime? get chronologicalDate {
    if (stardate != null) {
      // Convert stardate to approximate year for sorting
      // This is a rough approximation for sorting purposes
      if (stardate! < 1000) return DateTime(2151 + (stardate! / 100).round());
      if (stardate! < 2000) return DateTime(2265 + (stardate! / 1000).round());
      if (stardate! < 10000) return DateTime(2270 + ((stardate! - 1000) / 1000).round());
      if (stardate! < 50000) return DateTime(2364 + ((stardate! - 40000) / 1000).round());
      if (stardate! < 60000) return DateTime(2370 + ((stardate! - 50000) / 1000).round());
      return DateTime(2380 + ((stardate! - 57000) / 1000).round());
    }
    return airDate;
  }
}

class EpisodeChronologicalItem extends ChronologicalItem {
  final Episode episode;
  final String seriesAbbreviation;
  
  EpisodeChronologicalItem(this.episode, this.seriesAbbreviation);
  
  @override
  String get id => episode.id;
  @override
  String get title => episode.title;
  @override
  double? get stardate => episode.stardate;
  @override
  DateTime? get airDate => episode.airDate;
  @override
  bool get isWatched => episode.isWatched;
  @override
  bool get isFavorite => episode.isFavorite;
  @override
  DateTime? get watchedDate => episode.watchedDate;
  @override
  String get type => 'episode';
  
  String get subtitle => '$seriesAbbreviation S${episode.seasonNumber}E${episode.episodeNumber}';
}

class MovieChronologicalItem extends ChronologicalItem {
  final Movie movie;
  
  MovieChronologicalItem(this.movie);
  
  @override
  String get id => movie.id;
  @override
  String get title => movie.title;
  @override
  double? get stardate => movie.stardate;
  @override
  DateTime? get airDate => movie.releaseDate;
  @override
  bool get isWatched => movie.isWatched;
  @override
  bool get isFavorite => movie.isFavorite;
  @override
  DateTime? get watchedDate => movie.watchedDate;
  @override
  String get type => 'movie';
  
  String get subtitle => 'Movie';
}

// Recommended viewing order structure
class ViewingEra {
  final String title;
  final String description;
  final List<ViewingItem> items;

  ViewingEra({
    required this.title,
    required this.description,
    required this.items,
  });
}

class ViewingItem {
  final String id;
  final String title;
  final String type; // 'series', 'movie', 'season', 'episode'
  final String? subtitle;
  final String? note;
  final bool isOptional;

  ViewingItem({
    required this.id,
    required this.title,
    required this.type,
    this.subtitle,
    this.note,
    this.isOptional = false,
  });
}

class StarTrekShow {
  final String id;
  final String title;
  final String abbreviation;
  final DateTime timelineStart;
  final DateTime timelineEnd;
  final List<Season> seasons;
  final bool isMovie;
  final String? description;

  StarTrekShow({
    required this.id,
    required this.title,
    required this.abbreviation,
    required this.timelineStart,
    required this.timelineEnd,
    required this.seasons,
    this.isMovie = false,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'abbreviation': abbreviation,
    'timelineStart': timelineStart.toIso8601String(),
    'timelineEnd': timelineEnd.toIso8601String(),
    'seasons': seasons.map((s) => s.toJson()).toList(),
    'isMovie': isMovie,
    'description': description,
  };

  factory StarTrekShow.fromJson(Map<String, dynamic> json) => StarTrekShow(
    id: json['id'],
    title: json['title'],
    abbreviation: json['abbreviation'],
    timelineStart: DateTime.parse(json['timelineStart']),
    timelineEnd: DateTime.parse(json['timelineEnd']),
    seasons: (json['seasons'] as List).map((s) => Season.fromJson(s)).toList(),
    isMovie: json['isMovie'] ?? false,
    description: json['description'],
  );
}