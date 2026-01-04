import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _selectedMovieIdsKey = 'selected_movie_ids';
  static const String _selectedGenreIdsKey = 'selected_genre_ids';
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Selected Movies

  /// Save selected movie IDs from onboarding
  Future<bool> saveSelectedMovieIds(List<int> movieIds) async {
    final jsonString = jsonEncode(movieIds);
    return await _prefs.setString(_selectedMovieIdsKey, jsonString);
  }

  /// Get saved selected movie IDs
  List<int> getSelectedMovieIds() {
    try {
      final value = _prefs.get(_selectedMovieIdsKey);
      if (value == null) return [];
      if (value is! String) {
        // Clear corrupted data
        _prefs.remove(_selectedMovieIdsKey);
        return [];
      }
      final List<dynamic> decoded = jsonDecode(value);
      return decoded.cast<int>();
    } catch (_) {
      return [];
    }
  }

  // Selected Genres

  /// Save selected genre IDs from onboarding
  Future<bool> saveSelectedGenreIds(List<int> genreIds) async {
    final jsonString = jsonEncode(genreIds);
    return await _prefs.setString(_selectedGenreIdsKey, jsonString);
  }

  /// Get saved selected genre IDs
  List<int> getSelectedGenreIds() {
    try {
      final value = _prefs.get(_selectedGenreIdsKey);
      if (value == null) return [];
      if (value is! String) {
        // Clear corrupted data
        _prefs.remove(_selectedGenreIdsKey);
        return [];
      }
      final List<dynamic> decoded = jsonDecode(value);
      return decoded.cast<int>();
    } catch (_) {
      return [];
    }
  }

  // Onboarding Status

  /// Mark onboarding as completed
  Future<bool> setOnboardingCompleted(bool completed) async {
    return await _prefs.setBool(_hasCompletedOnboardingKey, completed);
  }

  /// Check if onboarding is completed
  bool hasCompletedOnboarding() {
    return _prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  // Helper Methods

  /// Clear all saved selections
  Future<void> clearSelections() async {
    await _prefs.remove(_selectedMovieIdsKey);
    await _prefs.remove(_selectedGenreIdsKey);
    await _prefs.remove(_hasCompletedOnboardingKey);
  }

  /// Check if user has any saved selections
  bool hasSelections() {
    return getSelectedMovieIds().isNotEmpty || getSelectedGenreIds().isNotEmpty;
  }
}
