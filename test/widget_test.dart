import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyn_flutter_app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ZYN app menyimpan onboarding dan langsung membuka beranda', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const ZynApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Mulai dengan ZYN'), findsOneWidget);

    await tester.ensureVisible(find.text('Teknologi'));
    await tester.tap(find.text('Teknologi'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lanjutkan ke Beranda'));
    await tester.tap(find.text('Lanjutkan ke Beranda'));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    await tester.pumpWidget(const ZynApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Mulai dengan ZYN'), findsNothing);
    expect(find.text('Beranda'), findsOneWidget);
  });
}
