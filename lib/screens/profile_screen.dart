import 'package:flutter/material.dart';

import '../state/app_controller.dart';

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
    final isDark = controller.themeMode == ThemeMode.dark;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile & Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text('Alex Rivera'),
                  subtitle: Text('alex.rivera@example.com'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: SwitchListTile(
                  value: isDark,
                  onChanged: controller.toggleTheme,
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Theme switching instan'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: SwitchListTile(
                  value: controller.notificationsEnabled,
                  onChanged: controller.toggleNotifications,
                  title: const Text('Notifications'),
                  subtitle: const Text('Aktifkan notifikasi berita terbaru'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Notification Center'),
                  subtitle: Text(
                    controller.unreadNotificationCount == 0
                        ? 'Tidak ada notifikasi baru'
                        : '${controller.unreadNotificationCount} notifikasi belum dibaca',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenNotifications,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                        children: FontScaleOption.values.map((option) {
                          return ChoiceChip(
                            label: Text(option.label),
                            selected: option == controller.fontScale,
                            onSelected: (_) => controller.setFontScale(option),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      const Text('Perubahan berlaku real-time.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('About App'),
                  subtitle: const Text('ZYN - Zenith Your News'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ZYN',
                      applicationVersion: 'MVP 1.0',
                      children: const [
                        Text(
                          'News aggregator dengan fokus keterbacaan dan kenyamanan semua usia.',
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onOpenLogin,
                child: const Text('Login (Phase 2)'),
              ),
            ],
          ),
        );
      },
    );
  }
}
