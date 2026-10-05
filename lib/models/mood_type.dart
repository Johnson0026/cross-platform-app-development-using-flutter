import 'package:flutter/material.dart';

/// Enum representing the 5 core mood types supported by MindLog.
///
/// Each mood is associated with an emoji icon, descriptive label,
/// numerical score, and a calming color representation.
enum MoodType {
  great,
  good,
  okay,
  low,
  awful;

  /// Returns the emoji character associated with the mood.
  String get emoji {
    switch (this) {
      case MoodType.great:
        return '😄';
      case MoodType.good:
        return '🙂';
      case MoodType.okay:
        return '😐';
      case MoodType.low:
        return '😔';
      case MoodType.awful:
        return '😢';
    }
  }

  /// Returns a user-friendly text label for the mood.
  String get label {
    switch (this) {
      case MoodType.great:
        return 'Great';
      case MoodType.good:
        return 'Good';
      case MoodType.okay:
        return 'Okay';
      case MoodType.low:
        return 'Low';
      case MoodType.awful:
        return 'Awful';
    }
  }

  /// Returns a numerical rating score from 1 (Awful) to 5 (Great).
  int get score {
    switch (this) {
      case MoodType.great:
        return 5;
      case MoodType.good:
        return 4;
      case MoodType.okay:
        return 3;
      case MoodType.low:
        return 2;
      case MoodType.awful:
        return 1;
    }
  }

  /// Returns a calming accent color corresponding to the mood.
  Color get color {
    switch (this) {
      case MoodType.great:
        return const Color(0xFF2E7D32); // Soothing green
      case MoodType.good:
        return const Color(0xFF00796B); // Calm teal
      case MoodType.okay:
        return const Color(0xFFF57F17); // Gentle amber
      case MoodType.low:
        return const Color(0xFF7E57C2); // Soft lavender/purple
      case MoodType.awful:
        return const Color(0xFFC62828); // Soft muted red
    }
  }

  /// Serializes the enum value to a string for JSON storage.
  String toJson() => name;

  /// Deserializes a string value back into a [MoodType] enum instance.
  /// Defaults to [MoodType.okay] if the string does not match any mood.
  static MoodType fromString(String val) {
    return MoodType.values.firstWhere(
      (m) => m.name.toLowerCase() == val.toLowerCase(),
      orElse: () => MoodType.okay,
    );
  }
}
