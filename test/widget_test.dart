import 'package:flutter_test/flutter_test.dart';
import 'package:zyn_flutter_app/app.dart';

void main() {
  testWidgets('ZYN app renders Home tab', (WidgetTester tester) async {
    await tester.pumpWidget(const ZynApp());
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Trending'), findsOneWidget);
  });
}
