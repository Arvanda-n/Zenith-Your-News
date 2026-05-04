import 'dart:async';

import 'package:flutter/material.dart';

import 'data/dummy_news.dart';
import 'screens/onboarding_screen.dart';
import 'screens/root_shell.dart';
import 'screens/splash_screen.dart';
import 'state/app_controller.dart';
import 'theme/app_theme.dart';
import 'utils/news_category.dart';

class ZynApp extends StatefulWidget {
  const ZynApp({super.key});

  @override
  State<ZynApp> createState() => _ZynAppState();
}

class _ZynAppState extends State<ZynApp> {
  final AppController _controller = AppController();
  bool _showSplash = true;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(const Duration(milliseconds: 1900), () {
      if (!mounted) {
        return;
      }
      setState(() => _showSplash = false);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = <String>{
      ...dummyNews.map((item) => item.categoryLabel),
    }.toList();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZYN - Zenith Your News',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _controller.themeMode,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: TextScaler.linear(_controller.fontScale.factor),
              ),
              child: child!,
            );
          },
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _showSplash
                ? const SplashScreen()
                : _controller.hasCompletedOnboarding
                    ? RootShell(
                        key: const ValueKey('root_shell'),
                        controller: _controller,
                      )
                    : OnboardingScreen(
                        key: const ValueKey('onboarding_screen'),
                        availableCategories: availableCategories,
                        onComplete: _controller.completeOnboarding,
                      ),
          ),
        );
      },
    );
  }
}
