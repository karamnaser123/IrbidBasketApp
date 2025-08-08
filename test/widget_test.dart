// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:irbid_basket/main.dart';

void main() {
  testWidgets('App basic test', (WidgetTester tester) async {
    // Ensure test binding is initialized and mock SharedPreferences so
    // plugin calls in widget tree do not fail in tests/CI.
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts properly
    expect(find.text('Irbid Basket'), findsOneWidget);
  });
}
