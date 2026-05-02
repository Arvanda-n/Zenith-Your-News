import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'state/app_controller.dart';
import 'theme/app_theme.dart';

class ZynApp extends StatefulWidget {
  const ZynApp({super.key});

  @override
  State<ZynApp> createState() => _ZynAppState();
}

class _ZynAppState extends State<ZynApp> {
  final AppController _controller = AppController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          home: RootShell(controller: _controller),
        );
      },
    );
  }
}
