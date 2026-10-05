import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../models/mood_type.dart';
import '../providers/entries_provider.dart';
import '../providers/theme_provider.dart';
import 'history_screen.dart';

/// Screen 2 of 3: Journal Entry Screen.
///
/// Provides a comfortable, focused writing editor environment for entering
/// daily reflections with form validation and live character count.
class JournalEntryScreen extends StatefulWidget {
  final MoodType selectedMood;
  final Entry? existingEntry;

  const JournalEntryScreen({
    super.key,
    required this.selectedMood,
    this.existingEntry,
  });

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _noteController;
  late MoodType _currentMood;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentMood = widget.selectedMood;
    _noteController = TextEditingController(
      text: widget.existingEntry?.note ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.existingEntry == null && _noteController.text.isEmpty) {
      final entriesProvider = Provider.of<EntriesProvider>(context, listen: false);
      final todayEntry = entriesProvider.todayEntry;
      if (todayEntry != null) {
        _noteController.text = todayEntry.note;
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveJournalEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final entriesProvider = Provider.of<EntriesProvider>(context, listen: false);
    final now = DateTime.now();
    final String entryId = widget.existingEntry?.id ??
        entriesProvider.todayEntry?.id ??
        now.millisecondsSinceEpoch.toString();

    await entriesProvider.saveOrUpdateEntry(
      id: entryId,
      date: widget.existingEntry?.date ?? now,
      mood: _currentMood,
      note: _noteController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.existingEntry != null || entriesProvider.todayEntry != null
                    ? 'Journal entry updated successfully!'
                    : 'Journal entry saved successfully!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final formattedToday = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    final moodColor = _currentMood.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindLog Note'),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Step Cue Badge
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_note_rounded,
                                  size: 15,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'STEP 2 OF 3 • JOURNAL NOTE',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section Title
                        Text(
                          'Today\'s Reflection',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Selected Mood Badge Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: moodColor.withValues(alpha: isDark ? 0.2 : 0.08),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: moodColor.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: moodColor.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _currentMood.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Feeling ${_currentMood.label}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: moodColor,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formattedToday,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Journal Input Card
                        Text(
                          'What\'s on your mind today?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: isDark ? 0.4 : 0.6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _noteController,
                                maxLines: 8,
                                maxLength: 500,
                                keyboardType: TextInputType.multiline,
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  height: 1.5,
                                  color: colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText:
                                      'Write freely. There are no right or wrong thoughts. Express how your day went...',
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                    fontSize: 14.5,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(20),
                                  counterText: '', // Custom counter below
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a short journal note before saving.';
                                  }
                                  if (value.trim().length > 500) {
                                    return 'Your note exceeds the maximum length of 500 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 15,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Journal Note',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${_noteController.text.length} / 500',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _noteController.text.length > 480
                                            ? Colors.redAccent
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Save Entry Button
                        FilledButton.icon(
                          onPressed: _isSaving ? null : _saveJournalEntry,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check_circle_rounded),
                          label: Text(_isSaving ? 'Saving Entry...' : 'Save Journal Entry'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Back Button
                        Center(
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            label: Text(
                              'Back to Mood Picker',
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
              ),
            );
          },
        ),
      ),
    );
  }
}
