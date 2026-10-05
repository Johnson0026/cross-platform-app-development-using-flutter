import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/entries_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/mood_picker_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

/// Entry point of the MindLog Flutter Application.
/// Author: Johnson Pillai (Roll No: 150096724110)
/// Course: B.Tech CSE & AI - Cross Platform App Development Major Project.
void main() async {
  // Ensure Flutter engine bindings are initialized before async disk access
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate local disk storage service
  final storageService = StorageService();

  // Pre-load theme settings and stored journal entries from disk
  final themeProvider = ThemeProvider(storageService: storageService);
  await themeProvider.initialize();

  final entriesProvider = EntriesProvider(storageService: storageService);
  await entriesProvider.loadEntries();

  runApp(
    MindLogApp(
      themeProvider: themeProvider,
      entriesProvider: entriesProvider,
    ),
  );
}

/// Root application widget configuring Material 3, providers, and theme state.
class MindLogApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final EntriesProvider entriesProvider;

  const MindLogApp({
    super.key,
    required this.themeProvider,
    required this.entriesProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<EntriesProvider>.value(value: entriesProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'MindLog - Mood & Journal Tracker',
            debugShowCheckedModeBanner: false,
            // Material 3 custom light & dark themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeNotifier.themeMode,
            // Smooth animated color transition on theme change
            themeAnimationDuration: const Duration(milliseconds: 350),
            themeAnimationCurve: Curves.easeInOut,
            // Default home route: Step 1 Mood Picker Screen
            home: const MoodPickerScreen(),
          );
        },
      ),
    );
  }
}
