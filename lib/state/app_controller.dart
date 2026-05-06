import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';

enum FontScaleOption {
  small(0.9, 'Kecil (0.9x)'),
  normal(1.0, 'Normal (1.0x)'),
  large(1.2, 'Besar (1.2x)'),
  extraLarge(1.4, 'Sangat besar (1.4x)');

  const FontScaleOption(this.factor, this.label);

  final double factor;
  final String label;
}

enum BookmarkActionResult { added, removed, loginRequired }

class AppController extends ChangeNotifier {
  AppController({SharedPreferences? preferences}) : _preferences = preferences;

  static const _themeModeKey = 'theme_mode';
  static const _fontScaleKey = 'font_scale';
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _isLoggedInKey = 'is_logged_in';
  static const _hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const _userNameKey = 'user_name';
  static const _userHandleKey = 'user_handle';
  static const _userEmailKey = 'user_email';
  static const _bookmarksKey = 'bookmarks';
  static const _preferredCategoriesKey = 'preferred_categories';
  static const _notificationsKey = 'notifications';

  SharedPreferences? _preferences;
  ThemeMode _themeMode = ThemeMode.light;
  FontScaleOption _fontScale = FontScaleOption.normal;
  bool _notificationsEnabled = true;
  bool _isLoggedIn = false;
  bool _isReady = false;
  bool _hasCompletedOnboarding = false;
  String? _userName;
  String? _userHandle;
  String? _userEmail;
  final Set<String> _bookmarks = <String>{};
  final Set<String> _preferredCategories = <String>{};
  List<AppNotification> _notifications = List<AppNotification>.from(
    _defaultNotifications,
  );

  static final List<AppNotification> _defaultNotifications = <AppNotification>[
    AppNotification(
      id: 'ntf-1',
      title: 'Breaking News',
      message: 'AI Bantu Produktivitas Tim Jarak Jauh Meningkat 2x Lipat',
      timestamp: DateTime(2026, 4, 28, 8, 30),
      newsId: 'n1',
    ),
    AppNotification(
      id: 'ntf-2',
      title: 'Pembaruan Tren',
      message: 'Ekonomi Hijau Dorong Investasi Baru di Asia Tenggara',
      timestamp: DateTime(2026, 4, 28, 7, 10),
      newsId: 'n6',
    ),
    AppNotification(
      id: 'ntf-3',
      title: 'Ringkasan Harian',
      message: '5 berita baru siap dibaca hari ini.',
      timestamp: DateTime(2026, 4, 27, 21, 0),
      newsId: 'n11',
      isRead: true,
    ),
  ];

  ThemeMode get themeMode => _themeMode;
  FontScaleOption get fontScale => _fontScale;
  bool get isReady => _isReady;
  Set<String> get bookmarks => _bookmarks;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String? get userName => _userName;
  String? get userHandle => _userHandle;
  String? get userEmail => _userEmail;
  List<AppNotification> get notifications => _notifications;
  Set<String> get preferredCategories => _preferredCategories;
  int get unreadNotificationCount =>
      _notifications.where((item) => !item.isRead).length;

  bool isBookmarked(String id) => _bookmarks.contains(id);

  Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
    _restorePersistedState();
    _isReady = true;
    notifyListeners();
  }

  void toggleTheme(bool darkEnabled) {
    _themeMode = darkEnabled ? ThemeMode.dark : ThemeMode.light;
    _persistState();
    notifyListeners();
  }

  void setFontScale(FontScaleOption option) {
    _fontScale = option;
    _persistState();
    notifyListeners();
  }

  void completeOnboarding(Iterable<String> selectedCategories) {
    _preferredCategories
      ..clear()
      ..addAll(
        selectedCategories
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    _hasCompletedOnboarding = true;
    _persistState();
    notifyListeners();
  }

  void updatePreferredCategories(Iterable<String> selectedCategories) {
    _preferredCategories
      ..clear()
      ..addAll(
        selectedCategories
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    _persistState();
    notifyListeners();
  }

  BookmarkActionResult toggleBookmark(String id) {
    if (!_isLoggedIn) {
      return BookmarkActionResult.loginRequired;
    }

    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
      _persistState();
      notifyListeners();
      return BookmarkActionResult.removed;
    }

    _bookmarks.add(id);
    _persistState();
    notifyListeners();
    return BookmarkActionResult.added;
  }

  void removeBookmark(String id) {
    _bookmarks.remove(id);
    _persistState();
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    _persistState();
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
    String? name,
    String? username,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return;
    }

    _isLoggedIn = true;
    _userEmail = email.trim();
    _userName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : _deriveNameFromEmail(email);
    _userHandle = _normalizeUsername(
      username?.trim().isNotEmpty == true ? username!.trim() : email,
    );
    _persistState();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    _userHandle = null;
    _userEmail = null;
    _bookmarks.clear();
    _persistState();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    _notifications = _notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    _persistState();
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications = _notifications
        .map((item) => item.copyWith(isRead: true))
        .toList();
    _persistState();
    notifyListeners();
  }

  Future<void> _persistState() async {
    final preferences = _preferences;
    if (preferences == null) {
      return;
    }

    await preferences.setString(_themeModeKey, _themeMode.name);
    await preferences.setString(_fontScaleKey, _fontScale.name);
    await preferences.setBool(_notificationsEnabledKey, _notificationsEnabled);
    await preferences.setBool(_isLoggedInKey, _isLoggedIn);
    await preferences.setBool(
      _hasCompletedOnboardingKey,
      _hasCompletedOnboarding,
    );
    await preferences.setStringList(
      _preferredCategoriesKey,
      _preferredCategories.toList(),
    );
    await preferences.setStringList(_bookmarksKey, _bookmarks.toList());

    if (_userName == null) {
      await preferences.remove(_userNameKey);
    } else {
      await preferences.setString(_userNameKey, _userName!);
    }

    if (_userHandle == null) {
      await preferences.remove(_userHandleKey);
    } else {
      await preferences.setString(_userHandleKey, _userHandle!);
    }

    if (_userEmail == null) {
      await preferences.remove(_userEmailKey);
    } else {
      await preferences.setString(_userEmailKey, _userEmail!);
    }

    await preferences.setStringList(
      _notificationsKey,
      _notifications.map((item) => jsonEncode(item.toMap())).toList(),
    );
  }

  void _restorePersistedState() {
    final preferences = _preferences;
    if (preferences == null) {
      return;
    }

    _themeMode = ThemeMode.values.byName(
      preferences.getString(_themeModeKey) ?? ThemeMode.light.name,
    );
    _fontScale = FontScaleOption.values.byName(
      preferences.getString(_fontScaleKey) ?? FontScaleOption.normal.name,
    );
    _notificationsEnabled =
        preferences.getBool(_notificationsEnabledKey) ?? true;
    _isLoggedIn = preferences.getBool(_isLoggedInKey) ?? false;
    _hasCompletedOnboarding =
        preferences.getBool(_hasCompletedOnboardingKey) ?? false;
    _userName = preferences.getString(_userNameKey);
    _userHandle = preferences.getString(_userHandleKey);
    _userEmail = preferences.getString(_userEmailKey);

    _bookmarks
      ..clear()
      ..addAll(preferences.getStringList(_bookmarksKey) ?? const <String>[]);
    _preferredCategories
      ..clear()
      ..addAll(
        preferences.getStringList(_preferredCategoriesKey) ?? const <String>[],
      );

    final storedNotifications = preferences.getStringList(_notificationsKey);
    if (storedNotifications == null || storedNotifications.isEmpty) {
      _notifications = List<AppNotification>.from(_defaultNotifications);
      return;
    }

    _notifications = storedNotifications
        .map(_parseNotification)
        .whereType<AppNotification>()
        .toList();
    if (_notifications.isEmpty) {
      _notifications = List<AppNotification>.from(_defaultNotifications);
    }
  }

  AppNotification? _parseNotification(String value) {
    try {
      final map = jsonDecode(value) as Map<String, dynamic>;
      return AppNotification.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  String _deriveNameFromEmail(String email) {
    final localPart = email.trim().split('@').first;
    if (localPart.isEmpty) {
      return 'Pembaca ZYN';
    }

    return localPart
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String _normalizeUsername(String raw) {
    final base = raw
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9._-]'), '')
        .replaceAll(RegExp(r'^[._-]+|[._-]+$'), '');
    return base.isEmpty ? 'pembacazyn' : base;
  }
}
