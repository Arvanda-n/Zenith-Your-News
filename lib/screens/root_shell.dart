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
          }) {
            widget.controller.login(
              email: email,
              password: password,
              name: name,
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

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(index: _tabIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            height: 78,
            selectedIndex: _tabIndex,
            onDestinationSelected: (value) => setState(() => _tabIndex = value),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_fire_department_outlined),
                selectedIcon: Icon(Icons.local_fire_department),
                label: 'Trending',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmark',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
