import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../models/news_item.dart';
import '../theme/app_theme.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class NotificationScreen extends StatefulWidget {
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

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _unreadOnly = false;

  String _timeLabel(DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    }
    return '${diff.inDays} hari lalu';
  }

  NewsItem? _findRelatedNews(String? newsId) {
    if (newsId == null) {
      return null;
    }

    for (final item in widget.news) {
      if (item.id == newsId) {
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final allNotifications = widget.controller.notifications;
        final notifications = _unreadOnly
            ? allNotifications.where((item) => !item.isRead).toList()
            : allNotifications;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.controller.unreadNotificationCount == 0
                          ? null
                          : widget.controller.markAllNotificationsRead,
                      child: const Text('Tandai semua dibaca'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.controller.unreadNotificationCount} pembaruan belum dibaca',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Pantau breaking news, digest harian, dan update kategori favoritmu.',
                              style: TextStyle(color: Colors.white70, height: 1.45),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: !_unreadOnly,
                      onSelected: (_) => setState(() => _unreadOnly = false),
                    ),
                    ChoiceChip(
                      label: const Text('Belum dibaca'),
                      selected: _unreadOnly,
                      onSelected: (_) => setState(() => _unreadOnly = true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (notifications.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Belum ada notifikasi untuk filter ini.'),
                    ),
                  )
                else
                  ...notifications.map((item) {
                    final relatedNews = _findRelatedNews(item.newsId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          minLeadingWidth: 64,
                          titleAlignment: ListTileTitleAlignment.top,
                          onTap: () {
                            widget.controller.markNotificationRead(item.id);
                            widget.onOpenNotification(item, relatedNews);
                          },
                          leading: relatedNews != null
                              ? NewsImage(
                                  imageUrl: relatedNews.imageUrl,
                                  imageHint: relatedNews.imageHint,
                                  width: 64,
                                  height: 64,
                                  borderRadius: BorderRadius.circular(14),
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
                                            .withValues(alpha: 0.18),
                                  child: Icon(
                                    item.isRead
                                        ? Icons.notifications_none
                                        : Icons.notifications_active,
                                  ),
                                ),
                          trailing: !item.isRead
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.brandGradient,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                )
                              : const Icon(Icons.chevron_right_rounded),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${item.message}\n${_timeLabel(item.timestamp)}',
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
