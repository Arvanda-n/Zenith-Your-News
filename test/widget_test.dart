import 'package:flutter_test/flutter_test.dart';
import 'package:zyn_flutter_app/app.dart';

void main() {
  testWidgets('ZYN app renders Indonesian navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const ZynApp());
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Tren'), findsOneWidget);
  });
}
