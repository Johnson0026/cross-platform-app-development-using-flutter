import 'package:flutter_test/flutter_test.dart';
import 'package:mindlog/models/entry.dart';
import 'package:mindlog/models/mood_type.dart';

void main() {
  group('MoodType Enum Tests', () {
    test('MoodType returns correct emojis and labels', () {
      expect(MoodType.great.emoji, equals('😄'));
      expect(MoodType.good.label, equals('Good'));
      expect(MoodType.okay.score, equals(3));
      expect(MoodType.low.emoji, equals('😔'));
      expect(MoodType.awful.label, equals('Awful'));
    });

    test('MoodType fromString parses valid and fallback values', () {
      expect(MoodType.fromString('great'), equals(MoodType.great));
      expect(MoodType.fromString('AWFUL'), equals(MoodType.awful));
      expect(MoodType.fromString('unknown_value'), equals(MoodType.okay));
    });
  });

  group('Entry Model JSON Round Trip Tests', () {
    test('Entry model serializes to JSON and deserializes correctly', () {
      final now = DateTime(2026, 10, 4, 14, 30);
      final originalEntry = Entry(
        id: 'test_entry_101',
        date: now,
        mood: MoodType.great,
        note: 'Had a productive day working on Flutter project!',
      );

      // Serialize to JSON Map
      final jsonMap = originalEntry.toJson();
      expect(jsonMap['id'], equals('test_entry_101'));
      expect(jsonMap['mood'], equals('great'));
      expect(jsonMap['note'], equals('Had a productive day working on Flutter project!'));

      // Deserialize back from JSON Map
      final reconstructedEntry = Entry.fromJson(jsonMap);

      // Verify JSON Round Trip equality
      expect(reconstructedEntry.id, equals(originalEntry.id));
      expect(reconstructedEntry.date, equals(originalEntry.date));
      expect(reconstructedEntry.mood, equals(originalEntry.mood));
      expect(reconstructedEntry.note, equals(originalEntry.note));
      expect(reconstructedEntry, equals(originalEntry));
    });

    test('Entry dateKey formats correctly as YYYY-MM-DD', () {
      final testDate = DateTime(2026, 5, 15);
      final entry = Entry(
        id: '1',
        date: testDate,
        mood: MoodType.good,
        note: 'Testing date key',
      );

      expect(entry.dateKey, equals('2026-05-15'));
    });

    test('Entry copyWith creates a updated copy correctly', () {
      final original = Entry(
        id: '1',
        date: DateTime.now(),
        mood: MoodType.okay,
        note: 'Original note',
      );

      final updated = original.copyWith(
        mood: MoodType.great,
        note: 'Updated note',
      );

      expect(updated.id, equals(original.id));
      expect(updated.mood, equals(MoodType.great));
      expect(updated.note, equals('Updated note'));
    });
  });
}
