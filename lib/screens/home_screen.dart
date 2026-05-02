import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.news,
    required this.onOpenDetail,
    required this.onOpenSearch,
    required this.onOpenNotifications,
  });

  final AppController controller;
  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    final featured = news.where((item) => item.featured).toList();
    final latest = List<NewsItem>.from(news)
      ..sort((a, b) => b.date.compareTo(a.date));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text(
                'ZYN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: onOpenSearch,
                  icon: const Icon(Icons.search),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: onOpenNotifications,
                      icon: const Icon(Icons.notifications_none),
                    ),
                    if (controller.notificationsEnabled &&
                        controller.unreadNotificationCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            controller.unreadNotificationCount > 9
                                ? '9+'
                                : '${controller.unreadNotificationCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured News',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = featured[index];
                          return _FeaturedCard(
                            item: item,
                            onTap: () => onOpenDetail(item),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemCount: featured.length,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Latest News',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverList.builder(
                itemCount: latest.length,
                itemBuilder: (context, index) {
                  final item = latest[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NewsTile(item: item, onTap: () => onOpenDetail(item)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            NewsImage(
              imageUrl: item.imageUrl,
              imageHint: item.imageHint,
              borderRadius: BorderRadius.circular(16),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(item.category),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsTile extends StatelessWidget {
  const _NewsTile({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA4A4A4)
        : const Color(0xFF6B7280);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                width: 86,
                height: 86,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.category} • ${item.readMinutes} min read',
                      style: TextStyle(color: secondaryColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
