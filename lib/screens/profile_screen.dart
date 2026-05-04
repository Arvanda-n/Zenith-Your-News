import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    required this.onOpenLogin,
    required this.onOpenNotifications,
  });

  final AppController controller;
  final VoidCallback onOpenLogin;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDark = controller.themeMode == ThemeMode.dark;
        final isLoggedIn = controller.isLoggedIn;

        return Scaffold(
          appBar: AppBar(title: const Text('Profile & Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        isLoggedIn ? Icons.person : Icons.person_outline,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoggedIn
                                ? controller.userName ?? 'ZYN Reader'
                                : 'Belum login',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isLoggedIn
                                ? controller.userEmail ?? ''
                                : 'Masuk untuk personalisasi, bookmark, dan sinkronisasi preferensi.',
                            style: const TextStyle(color: Colors.white70, height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _ProfileGroup(
                title: 'Preferences',
                children: [
                  SwitchListTile(
                    value: isDark,
                    onChanged: controller.toggleTheme,
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Tampilan yang lebih fokus untuk malam hari'),
                  ),
                  SwitchListTile(
                    value: controller.notificationsEnabled,
                    onChanged: controller.toggleNotifications,
                    title: const Text('Notifications'),
                    subtitle: const Text('Aktifkan update breaking news dan digest'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ProfileGroup(
                title: 'Reading Experience',
                children: [
                  ListTile(
                    title: const Text('Notification Center'),
                    subtitle: Text(
                      controller.unreadNotificationCount == 0
                          ? 'Tidak ada notifikasi baru'
                          : '${controller.unreadNotificationCount} notifikasi belum dibaca',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: onOpenNotifications,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Font Size',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: FontScaleOption.values.map((option) {
                            return ChoiceChip(
                              label: Text(option.label),
                              selected: option == controller.fontScale,
                              onSelected: (_) => controller.setFontScale(option),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ProfileGroup(
                title: 'About',
                children: [
                  ListTile(
                    title: const Text('About ZYN'),
                    subtitle: const Text('Zenith Your News'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'ZYN',
                        applicationVersion: 'MVP 1.0',
                        children: const [
                          Text(
                            'News aggregator modern dengan fokus kenyamanan baca, personalisasi, dan visual premium.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  if (isLoggedIn) {
                    controller.logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Berhasil logout.')),
                    );
                    return;
                  }
                  onOpenLogin();
                },
                child: Text(isLoggedIn ? 'Logout' : 'Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
