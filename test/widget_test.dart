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

    expect(find.widgetWithText(TextButton, 'Lewati'), findsOneWidget);
    final skipButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Lewati'),
    );
    skipButton.onPressed!.call();
    await tester.pumpAndSettle();

    expect(find.text('Pilih topik favoritmu'), findsOneWidget);
    expect(find.text('Lanjutkan ke Login'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan ke Login'));
    await tester.pumpAndSettle();

    expect(find.textContaining('akun ZYN'), findsOneWidget);
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

    expect(find.widgetWithText(TextButton, 'Lewati'), findsNothing);
    expect(find.text('Pilih topik favoritmu'), findsNothing);
    expect(find.textContaining('akun ZYN'), findsNothing);
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
        'user_bio': 'Editor teknologi dan tren digital.',
        'user_photo_path': 'storage/emulated/0/Pictures/nadia.png',
        'user_photo_scale': 1.4,
        'preferred_categories': <String>['Teknologi', 'Bisnis'],
      });

      final controller = AppController();
      await controller.initialize();

      expect(controller.themeMode, ThemeMode.light);
      expect(controller.fontScale, FontScaleOption.normal);
      expect(controller.fontScale.factor, 0.9);
      expect(controller.notificationsEnabled, isFalse);
      expect(controller.isLoggedIn, isTrue);
      expect(controller.hasCompletedOnboarding, isTrue);
      expect(controller.hasCompletedAuthGate, isTrue);
      expect(controller.lastSelectedTab, 3);
      expect(controller.userName, 'Nadia');
      expect(controller.userHandle, 'nadia.zyn');
      expect(controller.userEmail, 'nadia@zyn.app');
      expect(controller.userBio, 'Editor teknologi dan tren digital.');
      expect(controller.userPhotoPath, 'storage/emulated/0/Pictures/nadia.png');
      expect(controller.userPhotoScale, 1.4);
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
        'user_bio': 'Masih tersimpan',
        'user_photo_path': '/tmp/avatar.png',
        'bookmarks': <String>['n1'],
      });

      final controller = AppController();
      await controller.initialize();

      expect(controller.isLoggedIn, isFalse);
      expect(controller.userName, isNull);
      expect(controller.userHandle, isNull);
      expect(controller.userEmail, isNull);
      expect(controller.userBio, isNull);
      expect(controller.userPhotoPath, isNull);
      expect(controller.userPhotoScale, 1.0);
      expect(controller.bookmarks, isEmpty);
    },
  );

  test(
    'AppController menyimpan ukuran foto profil dan meresetnya saat logout',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      final controller = AppController();
      await controller.initialize();
      controller.login(email: 'foto@zyn.app', password: 'rahasia123');
      controller.updateProfilePhotoPath('/tmp/zyn-avatar.png');
      controller.updateProfilePhotoScale(1.6);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.userPhotoScale, 1.6);

      final restored = AppController();
      await restored.initialize();
      expect(restored.userPhotoScale, 1.6);

      restored.logout();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(restored.userPhotoPath, isNull);
      expect(restored.userPhotoScale, 1.0);
    },
  );
}
