import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyn_flutter_app/app.dart';
import 'package:zyn_flutter_app/state/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ZYN app membuka intro lalu topik sebelum lanjut ke auth gate', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const ZynApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang di ZYN'), findsWidgets);
    final skipButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Lewati'),
    );
    skipButton.onPressed!.call();
    await tester.pumpAndSettle();

    expect(find.text('Pilih topik favoritmu'), findsOneWidget);
    expect(find.text('Lanjutkan ke Login'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan ke Login'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke akun ZYN'), findsOneWidget);
    expect(find.text('Lewati dulu'), findsOneWidget);

    await tester.tap(find.text('Lewati dulu'));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    await tester.pumpWidget(const ZynApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang di ZYN'), findsNothing);
    expect(find.text('Pilih topik favoritmu'), findsNothing);
    expect(find.text('Masuk ke akun ZYN'), findsNothing);
    expect(find.text('Beranda'), findsOneWidget);
  });

  test(
    'AppController memulihkan preferensi sesi dan fallback aman untuk data lama',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'legacy-dark',
        'font_scale': 'legacy-large',
        'notifications_enabled': false,
        'is_logged_in': true,
        'has_completed_onboarding': true,
        'has_completed_auth_gate': true,
        'last_selected_tab': 3,
        'user_name': 'Nadia',
        'user_handle': 'nadia.zyn',
        'user_email': 'nadia@zyn.app',
        'preferred_categories': <String>['Teknologi', 'Bisnis'],
      });

      final controller = AppController();
      await controller.initialize();

      expect(controller.themeMode, ThemeMode.light);
      expect(controller.fontScale, FontScaleOption.normal);
      expect(controller.notificationsEnabled, isFalse);
      expect(controller.isLoggedIn, isTrue);
      expect(controller.hasCompletedOnboarding, isTrue);
      expect(controller.hasCompletedAuthGate, isTrue);
      expect(controller.lastSelectedTab, 3);
      expect(controller.userName, 'Nadia');
      expect(controller.userHandle, 'nadia.zyn');
      expect(controller.userEmail, 'nadia@zyn.app');
      expect(
        controller.preferredCategories,
        containsAll(<String>['Teknologi', 'Bisnis']),
      );

      await controller.setLastSelectedTab(1);

      final restored = AppController();
      await restored.initialize();

      expect(restored.lastSelectedTab, 1);
      expect(restored.notificationsEnabled, isFalse);
    },
  );

  test(
    'AppController membersihkan data akun lama saat status login tersimpan false',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'is_logged_in': false,
        'user_name': 'Tersisa',
        'user_handle': 'tersisa',
        'user_email': 'tersisa@zyn.app',
        'bookmarks': <String>['n1'],
      });

      final controller = AppController();
      await controller.initialize();

      expect(controller.isLoggedIn, isFalse);
      expect(controller.userName, isNull);
      expect(controller.userHandle, isNull);
      expect(controller.userEmail, isNull);
      expect(controller.bookmarks, isEmpty);
    },
  );
}
