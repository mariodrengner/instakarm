import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

void main() {
  testWidgets('StartScreen builds correctly smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We test the StartScreen directly to avoid router complexities in a simple test.
    await tester.pumpWidget(const MaterialApp(home: StartScreen()));

    // Verify that our starter widget builds.
    expect(find.text('InstaKarm'), findsOneWidget);
    expect(find.text('Level up your Mind'), findsOneWidget);

    // Verify that the button is present.
    expect(find.text('Los geht\'s'), findsOneWidget);
  });
}
