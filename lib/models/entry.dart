import 'package:intl/intl.dart';
import 'mood_type.dart';

/// Data model representing a single daily mood and journal entry.
///
/// Implements full immutability, JSON serialization/deserialization,
/// copyWith helper methods, and date comparison logic.
class Entry {
  /// Unique identifier for the journal entry (e.g. formatted date or UUID).
  final String id;

  /// The exact timestamp when the entry was created or updated.
  final DateTime date;

  /// The selected mood type associated with this entry.
  final MoodType mood;

  /// The user's written daily journal note.
  final String note;

  /// Creates a new immutable [Entry] instance.
  const Entry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  /// Formatted date key in "YYYY-MM-DD" format used for grouping and daily lookup.
  String get dateKey {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Human-readable date string (e.g. "Sunday, Oct 4, 2026").
  String get formattedDate {
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  /// Human-readable short time string (e.g. "2:30 PM").
  String get formattedTime {
    return DateFormat('h:mm a').format(date);
  }

  /// Converts this [Entry] object into a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood.toJson(),
      'note': note,
    };
  }

  /// Constructs an [Entry] object from a JSON Map.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      mood: MoodType.fromString(json['mood'] as String? ?? 'okay'),
      note: json['note'] as String? ?? '',
    );
  }

  /// Creates a copy of this entry with the given fields replaced with new values.
  Entry copyWith({
    String? id,
    DateTime? date,
    MoodType? mood,
    String? note,
  }) {
    return Entry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entry &&
        other.id == id &&
        other.date == date &&
        other.mood == mood &&
        other.note == note;
  }

  @override
  int get hashCode {
    return Object.hash(id, date, mood, note);
  }

  @override
  String toString() {
    return 'Entry(id: $id, dateKey: $dateKey, mood: ${mood.label}, note: $note)';
  }
}
