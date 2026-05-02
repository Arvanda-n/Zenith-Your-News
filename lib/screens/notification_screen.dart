import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../state/app_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.controller});

  final AppController controller;

  String _timeLabel(DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final notifications = controller.notifications;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              TextButton(
                onPressed: controller.unreadNotificationCount == 0
                    ? null
                    : controller.markAllNotificationsRead,
                child: const Text('Mark all read'),
              ),
            ],
          ),
          body: notifications.isEmpty
              ? const Center(child: Text('Belum ada notifikasi.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final AppNotification item = notifications[index];
                    return Card(
                      child: ListTile(
                        onTap: () => controller.markNotificationRead(item.id),
                        leading: CircleAvatar(
                          backgroundColor: item.isRead
                              ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.08)
                              : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2),
                          child: Icon(
                            item.isRead
                                ? Icons.notifications_none
                                : Icons.notifications_active,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('${item.message}\n${_timeLabel(item.timestamp)}'),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: notifications.length,
                ),
        );
      },
    );
  }
}
