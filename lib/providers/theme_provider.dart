import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Provider managing the global application theme state (Light/Dark mode).
///
/// Uses [ChangeNotifier] to broadcast theme updates to the entire widget tree
/// instantly, enabling smooth color transitions.
class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Current active [ThemeMode] (light or dark).
  ThemeMode get themeMode => _themeMode;

  /// Returns true if current theme mode is dark.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Returns true if initial theme settings have been loaded from disk.
  bool get isInitialized => _isInitialized;

  /// Initializes the provider by reading the saved theme setting from storage.
  Future<void> initialize() async {
    final isDark = await _storageService.loadThemeMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _isInitialized = true;
    notifyListeners();
  }

  /// Toggles between light and dark theme modes and persists the selection.
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _storageService.saveThemeMode(isDarkMode);
  }

  /// Explicitly sets the theme mode to [mode] and persists the selection.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _storageService.saveThemeMode(mode == ThemeMode.dark);
  }
}
