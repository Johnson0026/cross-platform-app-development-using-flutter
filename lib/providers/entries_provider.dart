import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';

/// Provider managing the list of journal entries and business logic.
///
/// Uses [ChangeNotifier] to update UI components whenever entries are added,
/// updated, or deleted.
class EntriesProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Entry> _entries = [];
  bool _isLoading = true;

  EntriesProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Unmodifiable view of all journal entries.
  List<Entry> get entries => List.unmodifiable(_entries);

  /// True while initial data is being read from disk storage.
  bool get isLoading => _isLoading;

  /// Total count of entries logged.
  int get count => _entries.length;

  /// Returns today's journal entry if one has already been created today.
  Entry? get todayEntry {
    final now = DateTime.now();
    return getEntryForDate(now);
  }

  /// Returns the entry logged on the exact calendar date specified by [date].
  Entry? getEntryForDate(DateTime date) {
    final String targetKey = DateFormat('yyyy-MM-dd').format(date);
    try {
      return _entries.firstWhere((e) => e.dateKey == targetKey);
    } catch (_) {
      return null;
    }
  }

  /// Returns entries grouped by formatted date section header (e.g. "Today", "Yesterday", "Oct 4, 2026").
  ///
  /// Maintains reverse-chronological order of date headers.
  Map<String, List<Entry>> get groupedEntries {
    final Map<String, List<Entry>> grouped = <String, List<Entry>>{};
    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayKey = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    for (final entry in _entries) {
      String header;
      if (entry.dateKey == todayKey) {
        header = 'Today';
      } else if (entry.dateKey == yesterdayKey) {
        header = 'Yesterday';
      } else {
        header = DateFormat('MMMM d, yyyy').format(entry.date);
      }

      if (!grouped.containsKey(header)) {
        grouped[header] = [];
      }
      grouped[header]!.add(entry);
    }

    return grouped;
  }

  /// Loads stored entries from on-device storage.
  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _storageService.loadEntries();
    _isLoading = false;
    notifyListeners();
  }

  /// Adds a new entry or updates an existing entry for the same day.
  ///
  /// Enforces the rule: **One entry per day**. If an entry already exists
  /// for the same calendar date, it will be updated.
  Future<void> saveOrUpdateEntry({
    required String id,
    required DateTime date,
    required dynamic mood,
    required String note,
  }) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final existingIndex = _entries.indexWhere((e) => e.dateKey == dateKey || e.id == id);

    final updatedEntry = Entry(
      id: existingIndex >= 0 ? _entries[existingIndex].id : id,
      date: date,
      mood: mood,
      note: note.trim(),
    );

    if (existingIndex >= 0) {
      _entries[existingIndex] = updatedEntry;
    } else {
      _entries.add(updatedEntry);
    }

    // Sort entries newest first
    _entries.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
    await _storageService.saveEntries(_entries);
  }

  /// Deletes an entry with the given [id] and updates disk storage.
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    await _storageService.saveEntries(_entries);
  }

  /// Clears all entries from memory and storage (useful for testing/reset).
  Future<void> clearAllEntries() async {
    _entries.clear();
    notifyListeners();
    await _storageService.saveEntries(_entries);
  }
}
