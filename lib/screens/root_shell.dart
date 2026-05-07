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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
        builder: (_) =>
            SearchScreen(news: dummyNews, onOpenDetail: _openDetail),
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
        builder: (_) =>
            CategoryScreen(news: dummyNews, onOpenDetail: _openDetail),
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
          onLogin:
              ({
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) => setState(() => _tabIndex = value),
            children: pages,
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161B2E).withValues(alpha: 0.96)
                    : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFF4F46E5).withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.black : const Color(0xFF4F46E5))
                        .withValues(alpha: isDark ? 0.30 : 0.12),
                    blurRadius: 36,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color:
                        (isDark
                                ? const Color(0xFF312E81)
                                : const Color(0xFF1D4ED8))
                            .withValues(alpha: isDark ? 0.22 : 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                        isDark: isDark,
                        onTap: () {
                          if (_tabIndex == index) {
                            return;
                          }
                          setState(() => _tabIndex = index);
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 360),
                            curve: Curves.easeOutCubic,
                          );
                        },
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
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark ? Colors.white70 : const Color(0xFF8C7AAE);
    final activeForeground = isDark ? Colors.white : const Color(0xFF3F2D7A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            height: 60,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 10 : 0,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [Color(0xFF3B82F6), Color(0xFF7C3AED)]
                          : const [Color(0xFFE0E7FF), Color(0xFFEDE9FE)],
                    )
                  : null,
              color: selected || !isDark
                  ? null
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 280),
                  offset: selected ? Offset.zero : const Offset(0, 0.08),
                  curve: Curves.easeOutCubic,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 280),
                    scale: selected ? 1.08 : 1,
                    curve: Curves.easeOutBack,
                    child: Icon(
                      selected ? selectedIcon : icon,
                      color: selected ? activeForeground : inactiveColor,
                      size: selected ? 24 : 23,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color: selected ? activeForeground : inactiveColor,
                    fontSize: selected ? 11.8 : 11.2,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.only(top: 4),
                  width: selected ? 18 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: selected
                        ? (isDark ? Colors.white : const Color(0xFF1B5FFF))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
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
