import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../models/app_notification.dart';
import '../models/news_item.dart';
import '../state/app_controller.dart';
import 'bookmark_screen.dart';
import 'category_screen.dart';
import 'detail_screen.dart';
import 'for_you_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'notification_detail_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'trending_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _tabIndex = 0;

  void _openDetail(NewsItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          controller: widget.controller,
          item: item,
          allNews: dummyNews,
          onRequireLogin: _openLogin,
        ),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(news: dummyNews, onOpenDetail: _openDetail),
      ),
    );
  }

  void _openForYou() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForYouScreen(
          news: dummyNews,
          userName: widget.controller.userName,
          onOpenDetail: _openDetail,
        ),
      ),
    );
  }

  void _openCategories() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          news: dummyNews,
          onOpenDetail: _openDetail,
        ),
      ),
    );
  }

  void _openNotificationDetail(
    AppNotification notification,
    NewsItem? relatedNews,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(
          notification: notification,
          relatedNews: relatedNews,
          onOpenDetail: _openDetail,
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationScreen(
          controller: widget.controller,
          news: dummyNews,
          onOpenNotification: _openNotificationDetail,
        ),
      ),
    );
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onLogin: ({
            required String email,
            required String password,
            String? name,
            String? username,
          }) {
            widget.controller.login(
              email: email,
              password: password,
              name: name,
              username: username,
            );
          },
          onForgotPassword: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        controller: widget.controller,
        news: dummyNews,
        onOpenDetail: _openDetail,
        onOpenSearch: _openSearch,
        onOpenNotifications: _openNotifications,
        onOpenForYou: _openForYou,
        onOpenCategories: _openCategories,
      ),
      TrendingScreen(
        controller: widget.controller,
        news: dummyNews,
        onOpenDetail: _openDetail,
      ),
      BookmarkScreen(
        controller: widget.controller,
        news: dummyNews,
        onOpenDetail: _openDetail,
        onOpenLogin: _openLogin,
      ),
      ProfileScreen(
        controller: widget.controller,
        onOpenLogin: _openLogin,
        onOpenNotifications: _openNotifications,
      ),
    ];

    const items = <_NavItemData>[
      _NavItemData(
        label: 'Beranda',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      _NavItemData(
        label: 'Tren',
        icon: Icons.local_fire_department_outlined,
        selectedIcon: Icons.local_fire_department,
      ),
      _NavItemData(
        label: 'Simpan',
        icon: Icons.bookmark_border,
        selectedIcon: Icons.bookmark,
      ),
      _NavItemData(
        label: 'Profil',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
      ),
    ];

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: _tabIndex, children: pages),
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                    blurRadius: 36,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final selected = index == _tabIndex;
                    return _BottomNavItem(
                      label: item.label,
                      icon: item.icon,
                      selectedIcon: item.selectedIcon,
                      selected: selected,
                      onTap: () => setState(() => _tabIndex = index),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = const Color(0xFF8C7AAE);
    final activeForeground = const Color(0xFF3F2D7A);
    final activeWidth = switch (label) {
      'Beranda' => 122.0,
      'Simpan' => 116.0,
      _ => 108.0,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            width: selected ? activeWidth : 56,
            height: 56,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 16 : 0,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE0E7FF),
                        Color(0xFFEDE9FE),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(999),
            ),
            child: selected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(selectedIcon, color: activeForeground, size: 22),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: activeForeground,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Icon(icon, color: inactiveColor, size: 24),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
