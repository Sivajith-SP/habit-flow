import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/bento_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/icon_cell.dart';

Widget _wrapWithTokens(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        extensions: [HabitFlowTokens.light],
      ),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 350,
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('IconCell Widget Tests', () {
    testWidgets('renders BentoCell with initial tone background and icons', (tester) async {
      int selectedTone = 0;
      IconData selectedIcon = Icons.water_drop_rounded;

      await tester.pumpWidget(
        _wrapWithTokens(
          StatefulBuilder(
            builder: (context, setState) => IconCell(
              selectedTone: selectedTone,
              selectedIcon: selectedIcon,
              onToneSelected: (t) => setState(() => selectedTone = t),
              onIconSelected: (i) => setState(() => selectedIcon = i),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BentoCell), findsOneWidget);
      expect(find.byType(IconCell), findsOneWidget);

      final bento = tester.widget<BentoCell>(find.byType(BentoCell));
      expect(bento.backgroundColor, HabitFlowTokens.light.tileMint);
    });

    testWidgets('selecting another tone changes BentoCell background color', (tester) async {
      int selectedTone = 0;
      IconData selectedIcon = Icons.water_drop_rounded;

      await tester.pumpWidget(
        _wrapWithTokens(
          StatefulBuilder(
            builder: (context, setState) => IconCell(
              selectedTone: selectedTone,
              selectedIcon: selectedIcon,
              onToneSelected: (t) => setState(() => selectedTone = t),
              onIconSelected: (i) => setState(() => selectedIcon = i),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Pink color tone swatch (second tone)
      await tester.tap(find.bySemanticsLabel('Pink color'));
      await tester.pumpAndSettle();

      expect(selectedTone, 1);
      final bentoAfter = tester.widget<BentoCell>(find.byType(BentoCell));
      expect(bentoAfter.backgroundColor, HabitFlowTokens.light.tilePink);
    });

    testWidgets('swiping icon row does not throw overflow', (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          IconCell(
            selectedTone: 0,
            selectedIcon: Icons.water_drop_rounded,
            onToneSelected: (_) {},
            onIconSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Drag/swipe horizontally across the icon list
      await tester.drag(find.byType(ListView), const Offset(-200, 0));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Drag back
      await tester.drag(find.byType(ListView), const Offset(200, 0));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping "+" opens icon picker bottom sheet and selects icon', (tester) async {
      int selectedTone = 0;
      IconData selectedIcon = Icons.water_drop_rounded;

      await tester.pumpWidget(
        _wrapWithTokens(
          StatefulBuilder(
            builder: (context, setState) => IconCell(
              selectedTone: selectedTone,
              selectedIcon: selectedIcon,
              onToneSelected: (t) => setState(() => selectedTone = t),
              onIconSelected: (i) => setState(() => selectedIcon = i),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll horizontally to "+" button
      await tester.scrollUntilVisible(
        find.byIcon(Icons.add_rounded),
        80,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      // Verify bottom sheet opened
      expect(find.text('Choose icon'), findsOneWidget);
      expect(find.text('Search icons'), findsOneWidget);
      expect(find.text('Icons'), findsOneWidget);
      expect(find.text('Emoji'), findsOneWidget);

      // Search for "cycling"
      await tester.enterText(find.byType(TextField), 'Cycling');
      await tester.pumpAndSettle();

      // Tap the cycling icon to select it
      expect(find.byIcon(Icons.pedal_bike_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.pedal_bike_rounded));
      await tester.pumpAndSettle();

      // Sheet should have closed and selectedIcon updated
      expect(find.text('Choose icon'), findsNothing);
      expect(selectedIcon, Icons.pedal_bike_rounded);

      // Custom icon should now appear as selected in the IconCell
      expect(find.byIcon(Icons.pedal_bike_rounded), findsOneWidget);
    });

    testWidgets('tapping Emoji tab switches to emoji grid and selecting emoji works', (tester) async {
      int selectedTone = 0;
      IconData selectedIcon = Icons.water_drop_outlined;

      await tester.pumpWidget(
        _wrapWithTokens(
          StatefulBuilder(
            builder: (context, setState) => IconCell(
              selectedTone: selectedTone,
              selectedIcon: selectedIcon,
              onToneSelected: (t) => setState(() => selectedTone = t),
              onIconSelected: (i) => setState(() => selectedIcon = i),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      // Switch to Emoji tab
      await tester.tap(find.text('Emoji'));
      await tester.pumpAndSettle();

      expect(find.text('Type or paste an emoji'), findsOneWidget);
      expect(find.text('Or pick one below.'), findsOneWidget);
      expect(find.text('🥗'), findsOneWidget);

      // Tap an emoji (e.g. 🥗)
      await tester.tap(find.text('🥗'));
      await tester.pumpAndSettle();

      // Sheet closes and emoji is selected
      expect(find.text('Choose icon'), findsNothing);
      expect(selectedIcon.codePoint, '🥗'.runes.first);
      expect(find.text('🥗'), findsOneWidget);
    });

    testWidgets('Add icon button is fixed outside ListView and ShaderMask provides fade', (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          IconCell(
            selectedTone: 0,
            selectedIcon: Icons.water_drop_outlined,
            onToneSelected: (_) {},
            onIconSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // ShaderMask is present
      expect(find.byType(ShaderMask), findsOneWidget);

      // The '+' add button is rendered outside ListView
      final listViewFinder = find.byType(ListView);
      final addIconFinder = find.byIcon(Icons.add_rounded);

      expect(addIconFinder, findsOneWidget);
      expect(
        find.descendant(of: listViewFinder, matching: addIconFinder),
        findsNothing,
      );
    });
  });
}
