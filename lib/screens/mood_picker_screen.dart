import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood_type.dart';
import '../providers/entries_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/mood_chip.dart';
import 'journal_entry_screen.dart';
import 'history_screen.dart';

/// Screen 1 of 3: Mood Picker Screen.
///
/// Prompts the user to select one of 5 mood categories with a modern,
/// calming wellness composition and animated feedback.
class MoodPickerScreen extends StatefulWidget {
  const MoodPickerScreen({super.key});

  @override
  State<MoodPickerScreen> createState() => _MoodPickerScreenState();
}

class _MoodPickerScreenState extends State<MoodPickerScreen> {
  MoodType? _selectedMood;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning 👋';
    } else if (hour < 17) {
      return 'Good afternoon 👋';
    } else {
      return 'Good evening 👋';
    }
  }

  void _onMoodSelected(MoodType mood) {
    setState(() {
      _selectedMood = mood;
    });

    // Navigate to Journal Entry Screen (Step 2 of 3)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JournalEntryScreen(selectedMood: mood),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);

    final todayEntry = entriesProvider.todayEntry;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindLog'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'View Journal History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth > 700 ? 640 : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section: Step Cue + Greeting + Title
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.spa_rounded,
                                size: 15,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'STEP 1 OF 3 • MOOD SELECTION',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Time-based Greeting & Headline
                      Text(
                        _getGreeting(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'How are you feeling today?',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take a moment to check in with yourself.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Existing Today Entry Notice (if applicable)
                      if (todayEntry != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                todayEntry.mood.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today\'s Mood Logged',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Currently logged as "${todayEntry.mood.label}". Tap any mood below to update.',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // 5 Mood Cards List / Column
                      Column(
                        children: MoodType.values.map((mood) {
                          final bool isSelected = _selectedMood == mood ||
                              (todayEntry?.mood == mood && _selectedMood == null);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: MoodChip(
                              mood: mood,
                              isSelected: isSelected,
                              onSelect: _onMoodSelected,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Primary CTA: Continue to Journal (if mood is selected)
                      if (_selectedMood != null)
                        FilledButton.icon(
                          onPressed: () => _onMoodSelected(_selectedMood!),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                          label: const Text('Continue to Journal'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Secondary Link: View Journal History
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HistoryScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.history_edu_rounded,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          label: Text(
                            'View Journal History',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
