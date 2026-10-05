import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

/// Repository service handling local on-device data persistence via [SharedPreferences].
///
/// Ensures all journal entries and application preferences (such as light/dark theme)
/// survive application restarts.
class StorageService {
  static const String _entriesKey = 'mindlog_entries_data_v1';
  static const String _themeModeKey = 'mindlog_is_dark_theme';

  /// Loads all persisted journal entries from on-device storage.
  ///
  /// Returns a list of [Entry] objects sorted in reverse chronological order (newest first).
  Future<List<Entry>> loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_entriesKey);

      if (jsonString == null || jsonString.trim().isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final List<Entry> entries = jsonList
          .map((item) => Entry.fromJson(item as Map<String, dynamic>))
          .toList();

      // Sort reverse chronological by date
      entries.sort((a, b) => b.date.compareTo(a.date));
      return entries;
    } catch (e, stackTrace) {
      debugPrint('Error loading entries from SharedPreferences: $e\n$stackTrace');
      return [];
    }
  }

  /// Persists the complete list of [Entry] objects to on-device storage.
  Future<bool> saveEntries(List<Entry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList =
          entries.map((entry) => entry.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      return await prefs.setString(_entriesKey, jsonString);
    } catch (e, stackTrace) {
      debugPrint('Error saving entries to SharedPreferences: $e\n$stackTrace');
      return false;
    }
  }

  /// Loads the persisted theme mode preference (returns true if dark mode is enabled).
  Future<bool> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themeModeKey) ?? false;
    } catch (e) {
      debugPrint('Error loading theme mode preference: $e');
      return false;
    }
  }

  /// Persists the user's theme preference (dark vs light mode).
  Future<bool> saveThemeMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_themeModeKey, isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme mode preference: $e');
      return false;
    }
  }
}
