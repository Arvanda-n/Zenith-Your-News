import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
    required this.controller,
    required this.news,
    required this.onOpenNotification,
  });

  final AppController controller;
  final List<NewsItem> news;
  final void Function(AppNotification notification, NewsItem? relatedNews)
  onOpenNotification;

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

  NewsItem? _findRelatedNews(String? newsId) {
    if (newsId == null) {
      return null;
    }

    for (final item in news) {
      if (item.id == newsId) {
        return item;
      }
    }
    return null;
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
                    final NewsItem? relatedNews = _findRelatedNews(item.newsId);

                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        minLeadingWidth: 64,
                        titleAlignment: ListTileTitleAlignment.top,
                        onTap: () {
                          controller.markNotificationRead(item.id);
                          onOpenNotification(item, relatedNews);
                        },
                        leading: relatedNews != null
                            ? NewsImage(
                                imageUrl: relatedNews.imageUrl,
                                imageHint: relatedNews.imageHint,
                                width: 64,
                                height: 64,
                                borderRadius: BorderRadius.circular(12),
                              )
                            : CircleAvatar(
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
                        trailing: const Icon(Icons.chevron_right),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${item.message}\n${_timeLabel(item.timestamp)}',
                          ),
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
