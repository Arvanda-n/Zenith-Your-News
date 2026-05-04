import 'package:flutter/material.dart';

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
  ThemeMode _themeMode = ThemeMode.light;
  FontScaleOption _fontScale = FontScaleOption.normal;
  bool _notificationsEnabled = true;
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;
  final Set<String> _bookmarks = <String>{};
  List<AppNotification> _notifications = <AppNotification>[
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
      newsId: 'n2',
    ),
    AppNotification(
      id: 'ntf-3',
      title: 'Daily Digest',
      message: '5 berita baru siap dibaca hari ini.',
      timestamp: DateTime(2026, 4, 27, 21, 0),
      newsId: 'n3',
      isRead: true,
    ),
  ];

  ThemeMode get themeMode => _themeMode;
  FontScaleOption get fontScale => _fontScale;
  Set<String> get bookmarks => _bookmarks;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationCount =>
      _notifications.where((item) => !item.isRead).length;

  bool isBookmarked(String id) => _bookmarks.contains(id);

  void toggleTheme(bool darkEnabled) {
    _themeMode = darkEnabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setFontScale(FontScaleOption option) {
    _fontScale = option;
    notifyListeners();
  }

  BookmarkActionResult toggleBookmark(String id) {
    if (!_isLoggedIn) {
      return BookmarkActionResult.loginRequired;
    }

    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
      notifyListeners();
      return BookmarkActionResult.removed;
    } else {
      _bookmarks.add(id);
      notifyListeners();
      return BookmarkActionResult.added;
    }
  }

  void removeBookmark(String id) {
    _bookmarks.remove(id);
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  void login({
    required String email,
    required String password,
    String? name,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return;
    }

    _isLoggedIn = true;
    _userEmail = email.trim();
    _userName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : _deriveNameFromEmail(email);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _bookmarks.clear();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    _notifications = _notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications =
        _notifications.map((item) => item.copyWith(isRead: true)).toList();
    notifyListeners();
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
          (part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
