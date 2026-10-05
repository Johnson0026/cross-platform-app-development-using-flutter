import 'package:flutter_test/flutter_test.dart';
import 'package:mindlog/main.dart';
import 'package:mindlog/models/mood_type.dart';
import 'package:mindlog/providers/entries_provider.dart';
import 'package:mindlog/providers/theme_provider.dart';

void main() {
  testWidgets('MoodPickerScreen displays all 5 mood options and navigates on tap', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    final entriesProvider = EntriesProvider();

    // Pump MindLogApp widget tree
    await tester.pumpWidget(
      MindLogApp(
        themeProvider: themeProvider,
        entriesProvider: entriesProvider,
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title and Step 1 Progress Cue are present
    expect(find.text('MindLog'), findsOneWidget);
    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.textContaining('STEP 1 OF 3'), findsOneWidget);

    // Verify all 5 mood labels are displayed
    for (final mood in MoodType.values) {
      expect(find.text(mood.label), findsOneWidget);
      expect(find.text(mood.emoji), findsOneWidget);
    }

    // Tap the 'Great' mood chip
    await tester.tap(find.text('Great'));

    // Allow scale + fade animation (300ms) and route transition to complete
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    // Verify navigation to Step 2 Journal Entry Screen
    expect(find.textContaining('STEP 2 OF 3'), findsOneWidget);
    expect(find.text('Feeling Great'), findsOneWidget);
    expect(find.text('What\'s on your mind today?'), findsOneWidget);
  });
}
