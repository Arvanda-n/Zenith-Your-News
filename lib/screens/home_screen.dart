import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _featuredController = PageController(viewportFraction: 0.92);
  int _featuredIndex = 0;

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = widget.news.where((item) => item.featured).toList();
    final latest = List<NewsItem>.from(widget.news)
      ..sort((a, b) => b.date.compareTo(a.date));

    return AnimatedBuilder(
      animation: widget.controller,
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
                  onPressed: widget.onOpenSearch,
                  icon: const Icon(Icons.search),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: widget.onOpenNotifications,
                      icon: const Icon(Icons.notifications_none),
                    ),
                    if (widget.controller.notificationsEnabled &&
                        widget.controller.unreadNotificationCount > 0)
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
                            widget.controller.unreadNotificationCount > 9
                                ? '9+'
                                : '${widget.controller.unreadNotificationCount}',
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
                      'Top Headlines',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Geser kartu untuk melihat headline utama lainnya.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 230,
                      child: PageView.builder(
                        controller: _featuredController,
                        itemCount: featured.length,
                        onPageChanged: (value) {
                          setState(() => _featuredIndex = value);
                        },
                        itemBuilder: (context, index) {
                          final item = featured[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == featured.length - 1 ? 0 : 12,
                            ),
                            child: _FeaturedCard(
                              item: item,
                              isActive: index == _featuredIndex,
                              onTap: () => widget.onOpenDetail(item),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(featured.length, (index) {
                        final isActive = index == _featuredIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        );
                      }),
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
                    child: _NewsTile(
                      item: item,
                      onTap: () => widget.onOpenDetail(item),
                    ),
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
  const _FeaturedCard({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final NewsItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: isActive ? 1 : 0.97,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
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
                padding: const EdgeInsets.all(18),
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
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, height: 1.4),
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
