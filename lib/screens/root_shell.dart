import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../models/news_item.dart';
import '../state/app_controller.dart';
import 'bookmark_screen.dart';
import 'detail_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
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
        builder: (_) => DetailScreen(controller: widget.controller, item: item),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(onOpenDetail: _openDetail),
      ),
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationScreen(controller: widget.controller),
      ),
    );
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (value) => setState(() => _tabIndex = value),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_fire_department_outlined),
                label: 'Trending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
