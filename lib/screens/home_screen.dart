import 'dart:async';

import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../utils/news_category.dart';
import '../widgets/news_image.dart';
import '../widgets/zyn_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.news,
    required this.onOpenDetail,
    required this.onOpenSearch,
    required this.onOpenNotifications,
    required this.onOpenForYou,
    required this.onOpenCategories,
  });

  final AppController controller;
  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenForYou;
  final VoidCallback onOpenCategories;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _headlineController = PageController(
    viewportFraction: 1,
  );
  Timer? _carouselTimer;
  int _headlineIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _headlineController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_headlineController.hasClients) {
        return;
      }

      final featuredCount = widget.news.where((item) => item.featured).length;
      if (featuredCount < 2) {
        return;
      }

      final nextIndex = (_headlineIndex + 1) % featuredCount;
      _headlineController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 460),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final compactLayout = media.size.width < 380;
    final preferredCategories = widget.controller.preferredCategories;
    final featuredItems = _prioritizeByPreference(
      widget.news.where((item) => item.featured),
      preferredCategories,
    ).take(5).toList();
    final curatedItems = _prioritizeByPreference(
      widget.news.where((item) => item.trendingScore >= 84),
      preferredCategories,
    ).take(6).toList();
    final latest = _sortLatest(widget.news, preferredCategories);
    final topicLabels = widget.news
        .map((item) => item.categoryLabel)
        .toSet()
        .take(8)
        .toList();

    final greeting = widget.controller.isLoggedIn
        ? 'Halo, ${widget.controller.userName ?? 'Pembaca ZYN'}'
        : 'Selamat datang di ZYN';
    final preferenceSummary = preferredCategories.isEmpty
        ? 'Berita premium yang disusun ringkas, visual, dan siap kamu jelajahi kapan pun.'
        : 'Feed hari ini diprioritaskan untuk: ${preferredCategories.join(', ')}';

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SafeArea(
                  bottom: false,
                  child: _TopHeroSection(
                    greeting: greeting,
                    preferenceSummary: preferenceSummary,
                    featuredItems: featuredItems,
                    headlineController: _headlineController,
                    headlineIndex: _headlineIndex,
                    compactLayout: compactLayout,
                    unreadNotificationCount:
                        widget.controller.notificationsEnabled
                        ? widget.controller.unreadNotificationCount
                        : 0,
                    onOpenSearch: widget.onOpenSearch,
                    onOpenNotifications: widget.onOpenNotifications,
                    onPageChanged: (value) =>
                        setState(() => _headlineIndex = value),
                    onOpenDetail: widget.onOpenDetail,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Untuk Anda',
                        subtitle: 'Kurasi personal',
                        icon: Icons.auto_awesome_rounded,
                        onTap: widget.onOpenForYou,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Kategori',
                        subtitle: 'Topik pilihan',
                        icon: Icons.grid_view_rounded,
                        onTap: widget.onOpenCategories,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionHeader(
                  title: 'Headline Utama',
                  subtitle:
                      'Sorotan besar dengan transisi otomatis dan navigasi swipe yang halus.',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: SizedBox(
                  height: compactLayout ? 236 : 254,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: curatedItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = curatedItems[index];
                      return _CuratedCard(
                        item: item,
                        compactLayout: compactLayout,
                        onTap: () => widget.onOpenDetail(item),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionHeader(
                  title: 'Jelajahi Topik',
                  subtitle:
                      'Kategori ringkas yang dibuat clean, ringan, dan mudah dipindai.',
                  actionLabel: 'Lihat semua',
                  onAction: widget.onOpenCategories,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: topicLabels
                      .map(
                        (label) => _TopicCard(
                          label: label,
                          icon: _topicIcons[label] ?? Icons.newspaper_rounded,
                          onTap: widget.onOpenCategories,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionHeader(
                  title: 'Berita Terbaru',
                  subtitle:
                      'Artikel lengkap dengan gaya layout yang lebih dekat ke aplikasi berita profesional.',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              sliver: SliverList.builder(
                itemCount: latest.length,
                itemBuilder: (context, index) {
                  final item = latest[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LatestTile(
                      item: item,
                      compactLayout: compactLayout,
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

  List<NewsItem> _prioritizeByPreference(
    Iterable<NewsItem> source,
    Set<String> preferredCategories,
  ) {
    final items = List<NewsItem>.from(source);
    items.sort((a, b) {
      final aPreferred = preferredCategories.contains(a.categoryLabel);
      final bPreferred = preferredCategories.contains(b.categoryLabel);
      if (aPreferred != bPreferred) {
        return aPreferred ? -1 : 1;
      }
      return b.trendingScore.compareTo(a.trendingScore);
    });
    return items;
  }

  List<NewsItem> _sortLatest(
    List<NewsItem> source,
    Set<String> preferredCategories,
  ) {
    final items = List<NewsItem>.from(source);
    items.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      if (byDate != 0) {
        return byDate;
      }
      final aPreferred = preferredCategories.contains(a.categoryLabel);
      final bPreferred = preferredCategories.contains(b.categoryLabel);
      if (aPreferred != bPreferred) {
        return aPreferred ? -1 : 1;
      }
      return b.trendingScore.compareTo(a.trendingScore);
    });
    return items;
  }
}

const Map<String, IconData> _topicIcons = <String, IconData>{
  'Teknologi': Icons.memory_rounded,
  'Ekonomi': Icons.trending_up_rounded,
  'Perkotaan': Icons.location_city_rounded,
  'Gaya Hidup': Icons.weekend_rounded,
  'Pendidikan': Icons.school_rounded,
  'Olahraga': Icons.sports_soccer_rounded,
  'Inovasi': Icons.lightbulb_rounded,
  'Wisata': Icons.explore_rounded,
  'Bisnis': Icons.business_center_rounded,
  'Kesehatan': Icons.favorite_rounded,
};

class _TopHeroSection extends StatelessWidget {
  const _TopHeroSection({
    required this.greeting,
    required this.preferenceSummary,
    required this.featuredItems,
    required this.headlineController,
    required this.headlineIndex,
    required this.compactLayout,
    required this.unreadNotificationCount,
    required this.onOpenSearch,
    required this.onOpenNotifications,
    required this.onPageChanged,
    required this.onOpenDetail,
  });

  final String greeting;
  final String preferenceSummary;
  final List<NewsItem> featuredItems;
  final PageController headlineController;
  final int headlineIndex;
  final bool compactLayout;
  final int unreadNotificationCount;
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenNotifications;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<NewsItem> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF0C49B8),
            Color(0xFF116FEF),
            Color(0xFF2EC5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ZynLogo(
                        size: 52,
                        radius: 16,
                        showPlate: true,
                        padding: EdgeInsets.all(4),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        greeting,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _HeroActionButton(
                  icon: Icons.search_rounded,
                  onTap: onOpenSearch,
                ),
                const SizedBox(width: 8),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _HeroActionButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: onOpenNotifications,
                    ),
                    if (unreadNotificationCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            unreadNotificationCount > 9
                                ? '9+'
                                : '$unreadNotificationCount',
                            style: const TextStyle(
                              color: Color(0xFF0C49B8),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              preferenceSummary,
              maxLines: compactLayout ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            if (featuredItems.isNotEmpty) ...[
              SizedBox(
                height: compactLayout ? 390 : 430,
                child: PageView.builder(
                  controller: headlineController,
                  itemCount: featuredItems.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final item = featuredItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _HeadlineCard(
                        item: item,
                        compactLayout: compactLayout,
                        showSwipeHint: featuredItems.length > 1,
                        onTap: () => onOpenDetail(item),
                      ),
                    );
                  },
                ),
              ),
              if (featuredItems.length > 1) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(featuredItems.length, (index) {
                          final active = index == headlineIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Auto',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _HeadlineCard extends StatelessWidget {
  const _HeadlineCard({
    required this.item,
    required this.compactLayout,
    required this.showSwipeHint,
    required this.onTap,
  });

  final NewsItem item;
  final bool compactLayout;
  final bool showSwipeHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            NewsImage(
              imageUrl: item.imageUrl,
              imageHint: item.imageHint,
              borderRadius: BorderRadius.circular(24),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.80),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.categoryLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (showSwipeHint)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.swipe_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Geser',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Oleh ${item.author} | ${item.readMinutes} menit baca',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item.title,
                    maxLines: compactLayout ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text('Baca sekarang'),
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

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 56) / 2;

    return SizedBox(
      width: width.clamp(150.0, 220.0),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CuratedCard extends StatelessWidget {
  const _CuratedCard({
    required this.item,
    required this.compactLayout,
    required this.onTap,
  });

  final NewsItem item;
  final bool compactLayout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compactLayout ? 240 : 272,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                height: 132,
                borderRadius: BorderRadius.zero,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.categoryLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          item.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height: 1.35),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${item.author} | ${item.readMinutes} menit baca',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestTile extends StatelessWidget {
  const _LatestTile({
    required this.item,
    required this.compactLayout,
    required this.onTap,
  });

  final NewsItem item;
  final bool compactLayout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Flex(
            direction: compactLayout ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                width: compactLayout ? double.infinity : 114,
                height: compactLayout ? 180 : 114,
                borderRadius: BorderRadius.circular(18),
              ),
              SizedBox(
                width: compactLayout ? 0 : 14,
                height: compactLayout ? 12 : 0,
              ),
              if (compactLayout)
                _LatestTileContent(item: item)
              else
                Expanded(child: _LatestTileContent(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestTileContent extends StatelessWidget {
  const _LatestTileContent({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.categoryLabel,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Text(
          '${item.author} | ${item.readMinutes} menit baca',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
