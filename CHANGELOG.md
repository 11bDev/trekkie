# Changelog

All notable changes to the Trekkie app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
