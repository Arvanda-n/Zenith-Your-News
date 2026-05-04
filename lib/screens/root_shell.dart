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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF312E81).withValues(alpha: 0.22),
                    blurRadius: 36,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final selected = index == _tabIndex;
                    return Expanded(
                      child: _BottomNavItem(
                        label: item.label,
                        icon: item.icon,
                        selectedIcon: item.selectedIcon,
                        selected: selected,
                        onTap: () => setState(() => _tabIndex = index),
                      ),
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
    final foreground = selected ? const Color(0xFF1E1B4B) : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withValues(alpha: 0.96)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFDBEAFE).withValues(alpha: 0.7),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE0E7FF)
                        : Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selected ? selectedIcon : icon,
                    color: foreground,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
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
