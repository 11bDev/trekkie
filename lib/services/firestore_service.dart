import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // User data collection reference
  CollectionReference get _userDataCollection =>
      _firestore.collection('userData');

  // ==================== EPISODES ====================

  // Mark episode as watched
  Future<void> markEpisodeWatched(String episodeId, bool watched) async {
    if (_userId == null) throw Exception('No user signed in');

    final docRef = _userDataCollection.doc(_userId);

    if (watched) {
      await docRef.set({
        'watchedEpisodes': {
          episodeId: {
            'watchedAt': FieldValue.serverTimestamp(),
            'watched': true,
          }
        }
      }, SetOptions(merge: true));
    } else {
      await docRef.update({
        'watchedEpisodes.$episodeId': FieldValue.delete(),
      });
    }
  }

  // Mark episode as favorite
  Future<void> markEpisodeFavorite(String episodeId, bool favorite) async {
    if (_userId == null) throw Exception('No user signed in');

    final docRef = _userDataCollection.doc(_userId);

    if (favorite) {
      await docRef.set({
        'favoriteEpisodes': {
          episodeId: {
            'favoritedAt': FieldValue.serverTimestamp(),
            'favorite': true,
          }
        }
      }, SetOptions(merge: true));
    } else {
      await docRef.update({
        'favoriteEpisodes.$episodeId': FieldValue.delete(),
      });
    }
  }

  // Get watched episodes for current user
  Future<List<String>> getWatchedEpisodes() async {
    if (_userId == null) return [];

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>?;
    final watchedEpisodes = data?['watchedEpisodes'] as Map<String, dynamic>?;

    return watchedEpisodes?.keys.toList() ?? [];
  }

  // Get favorite episodes for current user
  Future<List<String>> getFavoriteEpisodes() async {
    if (_userId == null) return [];

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>?;
    final favoriteEpisodes =
        data?['favoriteEpisodes'] as Map<String, dynamic>?;

    return favoriteEpisodes?.keys.toList() ?? [];
  }

  // Get episode watch date
  Future<DateTime?> getEpisodeWatchDate(String episodeId) async {
    if (_userId == null) return null;

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    final watchedEpisodes = data?['watchedEpisodes'] as Map<String, dynamic>?;
    final episodeData = watchedEpisodes?[episodeId] as Map<String, dynamic>?;

    final timestamp = episodeData?['watchedAt'] as Timestamp?;
    return timestamp?.toDate();
  }

  // ==================== MOVIES ====================

  // Mark movie as watched
  Future<void> markMovieWatched(String movieId, bool watched) async {
    if (_userId == null) throw Exception('No user signed in');

    final docRef = _userDataCollection.doc(_userId);

    if (watched) {
      await docRef.set({
        'watchedMovies': {
          movieId: {
            'watchedAt': FieldValue.serverTimestamp(),
            'watched': true,
          }
        }
      }, SetOptions(merge: true));
    } else {
      await docRef.update({
        'watchedMovies.$movieId': FieldValue.delete(),
      });
    }
  }

  // Mark movie as favorite
  Future<void> markMovieFavorite(String movieId, bool favorite) async {
    if (_userId == null) throw Exception('No user signed in');

    final docRef = _userDataCollection.doc(_userId);

    if (favorite) {
      await docRef.set({
        'favoriteMovies': {
          movieId: {
            'favoritedAt': FieldValue.serverTimestamp(),
            'favorite': true,
          }
        }
      }, SetOptions(merge: true));
    } else {
      await docRef.update({
        'favoriteMovies.$movieId': FieldValue.delete(),
      });
    }
  }

  // Get watched movies for current user
  Future<List<String>> getWatchedMovies() async {
    if (_userId == null) return [];

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>?;
    final watchedMovies = data?['watchedMovies'] as Map<String, dynamic>?;

    return watchedMovies?.keys.toList() ?? [];
  }

  // Get favorite movies for current user
  Future<List<String>> getFavoriteMovies() async {
    if (_userId == null) return [];

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>?;
    final favoriteMovies = data?['favoriteMovies'] as Map<String, dynamic>?;

    return favoriteMovies?.keys.toList() ?? [];
  }

  // Get movie watch date
  Future<DateTime?> getMovieWatchDate(String movieId) async {
    if (_userId == null) return null;

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    final watchedMovies = data?['watchedMovies'] as Map<String, dynamic>?;
    final movieData = watchedMovies?[movieId] as Map<String, dynamic>?;

    final timestamp = movieData?['watchedAt'] as Timestamp?;
    return timestamp?.toDate();
  }

  // ==================== USER STATS ====================

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    if (_userId == null) return {};

    final doc = await _userDataCollection.doc(_userId).get();
    if (!doc.exists) return {};

    final data = doc.data() as Map<String, dynamic>?;

    return {
      'watchedEpisodesCount':
          (data?['watchedEpisodes'] as Map<String, dynamic>?)?.length ?? 0,
      'favoriteEpisodesCount':
          (data?['favoriteEpisodes'] as Map<String, dynamic>?)?.length ?? 0,
      'watchedMoviesCount':
          (data?['watchedMovies'] as Map<String, dynamic>?)?.length ?? 0,
      'favoriteMoviesCount':
          (data?['favoriteMovies'] as Map<String, dynamic>?)?.length ?? 0,
    };
  }

  // ==================== REAL-TIME SYNC ====================

  // Stream of user data changes
  Stream<DocumentSnapshot> get userDataStream {
    if (_userId == null) {
      return Stream.empty();
    }
    return _userDataCollection.doc(_userId).snapshots();
  }

  // Initialize user document if it doesn't exist
  Future<void> initializeUserDocument() async {
    if (_userId == null) return;

    final docRef = _userDataCollection.doc(_userId);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'watchedEpisodes': {},
        'favoriteEpisodes': {},
        'watchedMovies': {},
        'favoriteMovies': {},
      });
    }
  }

  // Clear all user data (for account deletion or reset)
  Future<void> clearUserData() async {
    if (_userId == null) return;

    await _userDataCollection.doc(_userId).delete();
  }
}
