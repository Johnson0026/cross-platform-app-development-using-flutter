import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../providers/entries_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/entry_tile.dart';
import 'entry_detail_screen.dart';
import 'mood_picker_screen.dart';

/// Screen 3 of 3: Entry History Screen.
///
/// Displays journal entries grouped by date using a grouped [ListView.builder].
/// Features a wellness summary header, swipe-to-delete confirmation, empty state,
/// and responsive dual-pane split view on wide screens.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Entry? _selectedEntryForWideScreen;

  Future<bool?> _confirmDeleteDialog(BuildContext context, Entry entry) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Confirm Deletion'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete the journal entry for ${entry.formattedDate}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 42,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your journal is waiting for you',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by checking in with how you feel today.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.5,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MoodPickerScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Pick Today\'s Mood'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSummary(
    BuildContext context,
    EntriesProvider entriesProvider,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final entries = entriesProvider.entries;
    final totalCount = entriesProvider.count;
    final latestEntry = entries.isNotEmpty ? entries.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Total Entries Badge Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: isDark ? 0.4 : 0.6),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalCount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Total Entries',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Latest Mood Badge Card
          if (latestEntry != null)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: isDark ? 0.4 : 0.6),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      latestEntry.mood.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latestEntry.mood.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: latestEntry.mood.color,
                          ),
                        ),
                        Text(
                          'Recent Mood',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryList({
    required BuildContext context,
    required Map<String, List<Entry>> groupedEntries,
    required ColorScheme colorScheme,
    required bool isWide,
  }) {
    final dateHeaders = groupedEntries.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: dateHeaders.length,
      itemBuilder: (context, sectionIndex) {
        final header = dateHeaders[sectionIndex];
        final dayEntries = groupedEntries[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header Tag
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
              child: Text(
                header.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: colorScheme.primary,
                ),
              ),
            ),

            // Entries under date header
            ...dayEntries.map((entry) {
              return Dismissible(
                key: Key(entry.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Swipe to Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.delete_forever, color: Colors.white),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  final confirmed = await _confirmDeleteDialog(context, entry);
                  return confirmed ?? false;
                },
                onDismissed: (direction) async {
                  final provider = Provider.of<EntriesProvider>(context, listen: false);
                  await provider.deleteEntry(entry.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Journal entry deleted.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    );
                  }
                },
                child: EntryTile(
                  entry: entry,
                  onTap: () {
                    if (isWide) {
                      setState(() {
                        _selectedEntryForWideScreen = entry;
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EntryDetailScreen(entry: entry),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);

    final grouped = entriesProvider.groupedEntries;
    final bool isEmpty = grouped.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal History'),
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
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Add Today\'s Entry',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MoodPickerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Cue Pill
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_edu_rounded,
                    size: 15,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STEP 3 OF 3 • JOURNAL HISTORY',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                children: [
                  Text(
                    'Your Journal',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Look back at your thoughts and feelings.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Summary Header Row
            if (!isEmpty)
              _buildHeaderSummary(context, entriesProvider, colorScheme, isDark),

            // Main List Area
            Expanded(
              child: entriesProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isEmpty
                      ? _buildEmptyState(context, colorScheme)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final bool isWide = constraints.maxWidth >= 750;

                            if (!isWide) {
                              return Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 640),
                                  child: _buildHistoryList(
                                    context: context,
                                    groupedEntries: grouped,
                                    colorScheme: colorScheme,
                                    isWide: false,
                                  ),
                                ),
                              );
                            }

                            // Dual Pane Layout on Wide Screen
                            final allEntries = entriesProvider.entries;
                            final activeEntry = _selectedEntryForWideScreen ??
                                (allEntries.isNotEmpty ? allEntries.first : null);

                            return Row(
                              children: [
                                SizedBox(
                                  width: 380,
                                  child: _buildHistoryList(
                                    context: context,
                                    groupedEntries: grouped,
                                    colorScheme: colorScheme,
                                    isWide: true,
                                  ),
                                ),
                                const VerticalDivider(width: 1),
                                Expanded(
                                  child: activeEntry == null
                                      ? const Center(child: Text('Select an entry to view details'))
                                      : EntryDetailScreen(entry: activeEntry),
                                ),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MoodPickerScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Log Today'),
        backgroundColor: colorScheme.primary,
        foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      ),
    );
  }
}
