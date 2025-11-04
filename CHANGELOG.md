# Changelog

All notable changes to the Trekkie app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-11-04

### 🔥 Major Changes - Firebase Migration & Multi-Tenant Support

### Added
- **Firebase Authentication**: Email/password and Google Sign-In support
- **Multi-Tenant Architecture**: Each user has their own isolated data
- **Cloud Firestore Integration**: Real-time cloud sync across all devices
- **Cross-Device Sync**: Watch history automatically syncs between Android and Web
- **User Profiles**: Display name, email, and viewing statistics
- **Web Platform Support**: Full progressive web app (PWA) with Firebase
- **Authentication Screens**: Login, signup, and profile management
- **Real-time Data Sync**: Changes sync instantly across all logged-in devices
- **Server-side Timestamps**: Accurate watch dates from Firebase servers
- **Firebase Setup Guide**: Comprehensive documentation in FIREBASE_SETUP.md

### Changed
- **Breaking**: Migrated from SharedPreferences to Cloud Firestore
- **Breaking**: Removed Linux desktop support (focus on Android and Web)
- **Version**: Bumped to 2.0.0 to reflect major architectural changes
- **Authentication**: Now required to use the app
- **Data Storage**: All user data now stored in Firebase Cloud Firestore
- **Dependencies**: Replaced `shared_preferences` with Firebase packages

### Removed
- **Linux Support**: Removed all Linux desktop files and installation scripts
  - Deleted `linux/` directory
  - Removed `.sh` installation scripts
  - Removed Linux-specific configurations
- **Local-only Storage**: Removed SharedPreferences-based data persistence
- **Welcome Dialog**: Removed first-launch dialog (replaced with auth flow)

### Technical
- Added `firebase_core: ^3.6.0`
- Added `firebase_auth: ^5.3.1`
- Added `cloud_firestore: ^5.4.4`
- Added `google_sign_in: ^6.2.1`
- Removed `shared_preferences: ^2.2.2`
- Created `lib/services/auth_service.dart`
- Created `lib/services/firestore_service.dart`
- Created `lib/screens/login_screen.dart`
- Created `lib/screens/signup_screen.dart`
- Created `lib/screens/profile_screen.dart`
- Created `web/index.html` with Firebase SDK integration
- Updated `lib/main.dart` with auth wrapper and Firebase initialization
- Updated `StarTrekService` to use Firestore instead of SharedPreferences

### Security
- Implemented Firebase Security Rules for user data isolation
- Added secure authentication with industry-standard Firebase Auth
- All data encrypted in transit with HTTPS/TLS
- Private user data - each user can only access their own information

### Migration Notes
**Important**: This version requires Firebase setup before running:
1. Create a Firebase project
2. Add Android and Web apps in Firebase Console
3. Download configuration files
4. Update Firebase config in `lib/main.dart` and `web/index.html`
5. See `FIREBASE_SETUP.md` for detailed instructions

Existing users will need to create an account and re-mark their watched episodes, as data is no longer stored locally.

## [1.1.0] - 2025-10-27

### Added
- **Android Support**: Full Android platform implementation with Kotlin DSL
  - Gradle 8.11.1 with Android Gradle Plugin 8.9.1
  - Kotlin 2.1.0 for modern Android development
  - Compatible with Android 16 (API 36) and later
- **Smart Navigation**: Click any series or movie in Recommended tab to jump directly to it
  - Automatically navigates to correct tab (By Series or Movies)
  - Expands the show and target season
  - Scrolls to last watched or first unwatched episode
  - Expansion state persists to prevent auto-collapse
- **The Animated Series**: Added all episodes from Star Trek: The Animated Series (1973-1974)
  - 22 episodes across 2 seasons
  - Chronologically placed in Pre-Federation Era
  - Expands the original crew's adventures with unlimited animation budget
- **Lower Decks Season 5**: Added the final season of Lower Decks
  - 10 new episodes completing the series
  - Brings the crew's journey to a satisfying conclusion
- **Section 31 Movie**: Added Star Trek: Section 31 (2025)
  - Michelle Yeoh's Georgiou leads Starfleet's black ops division
  - Placed in Early 24th Century timeline
  - Expands the Star Trek movie collection to 14 films
- **Welcome Dialog**: First-time users see a welcome message explaining the app
  - Only shows once using SharedPreferences
  - Introduces the chronological viewing concept
  - Sets expectations for the unique viewing experience

### Changed
- **Movies Tab UI**: Converted from horizontal tabs to expansion tiles (dropdown menus)
  - Consistent UI with By Series tab
  - Better organization of movies by timeline
  - Improved navigation and visual hierarchy
- **Expansion State Management**: Implemented robust key-based widget management
  - ExpansionTileController for programmatic expansion
  - Stable keys prevent unwanted widget recreation
  - Smooth expansion animations without auto-collapse

### Fixed
- **Season Detection Logic**: Improved algorithm for finding target season
  - Correctly identifies seasons with both watched and unwatched episodes
  - Falls back to last watched season if all episodes watched
  - Defaults to Season 1 for unwatched shows
- **Navigation Stability**: Fixed auto-collapse issue when navigating from Recommended tab
  - Widget keys remain stable after expansion
  - State persists across rebuilds
  - Smooth user experience without unexpected collapses

### Technical
- Updated episode count from 800+ to 900+ episodes
- Updated movie count from 13 to 14 films
- Improved debug logging for navigation and expansion events
- Enhanced state management for better performance

## [1.0.0] - 2025-10-26

### Added
- Initial release of Trekkie app
- Complete Star Trek episode database (800+ episodes)
- All 13 Star Trek movies
- Chronological viewing order organized into 6 eras
- Watch tracking with timestamps
- Favorites system for episodes and movies
- Progress tracking with visual indicators
- Statistics dashboard
- Linux desktop support with installation scripts
- Captain avatars for each series
- Episode and movie details with stardates
- SharedPreferences for data persistence
- Comprehensive viewing guide with era-based organization

### Features
- **Recommended Viewing Tab**: Expert-curated chronological order
- **By Series Tab**: Browse all shows with expandable seasons
- **Movies Tab**: Complete movie collection
- **Statistics**: Detailed viewing statistics and progress
- **Data Persistence**: Watch history and favorites saved locally
- **Offline Support**: Full functionality without internet connection
