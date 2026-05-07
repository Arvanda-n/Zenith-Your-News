import 'dart:async';

import 'package:flutter/material.dart';

import 'data/dummy_news.dart';
import 'screens/onboarding_screen.dart';
import 'screens/root_shell.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'state/app_controller.dart';
import 'theme/app_theme.dart';
import 'utils/news_category.dart';

class ZynApp extends StatefulWidget {
  const ZynApp({super.key, this.controller});

  final AppController? controller;

  @override
  State<ZynApp> createState() => _ZynAppState();
}

class _ZynAppState extends State<ZynApp> {
  late final AppController _controller;
  late final bool _ownsController;
  bool _showSplash = true;
  bool _splashElapsed = false;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AppController();
    _ownsController = widget.controller == null;
    _splashTimer = Timer(const Duration(milliseconds: 1900), () {
      if (!mounted) {
        return;
      }
      _splashElapsed = true;
      _syncLaunchState();
    });
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _syncLaunchState();
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _syncLaunchState() {
    final shouldShowSplash = !_splashElapsed || !_controller.isReady;
    if (_showSplash != shouldShowSplash) {
      setState(() => _showSplash = shouldShowSplash);
    }
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
                ? _controller.isLoggedIn || _controller.hasCompletedAuthGate
                      ? RootShell(
                          key: const ValueKey('root_shell'),
                          controller: _controller,
                        )
                      : LoginScreen(
                          key: const ValueKey('login_gate_screen'),
                          showBackButton: false,
                          canSkip: true,
                          onSkip: _controller.completeAuthGate,
                          onLogin:
                              ({
                                required String email,
                                required String password,
                                String? name,
                                String? username,
                              }) {
                                _controller.login(
                                  email: email,
                                  password: password,
                                  name: name,
                                  username: username,
                                );
                              },
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
