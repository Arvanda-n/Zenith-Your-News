import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';
import '../utils/news_category.dart';
import '../widgets/news_image.dart';

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
  final PageController _headlineController = PageController();
  int _headlineIndex = 0;

  @override
  void dispose() {
    _headlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    final highlightedCategories = <String, int>{};
    for (final item in widget.news) {
      highlightedCategories.update(
        item.categoryLabel,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    final categoryEntries = highlightedCategories.entries.take(6).toList();

    final greeting = widget.controller.isLoggedIn
        ? 'Halo, ${widget.controller.userName ?? 'Pembaca ZYN'}'
        : 'Selamat datang di ZYN';
    final preferenceSummary = preferredCategories.isEmpty
        ? 'Buka berita penting hari ini dengan sorotan visual yang lebih rapi dan mudah dijelajahi.'
        : 'Fokus hari ini: ${preferredCategories.join(', ')}';

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
                        subtitle: 'Jelajahi topik',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: 'Untuk Anda',
                      subtitle: preferredCategories.isEmpty
                          ? 'Pilihan paling relevan berdasarkan momentum hari ini.'
                          : 'Kurasi diprioritaskan dari minat yang kamu pilih saat onboarding.',
                      actionLabel: 'Buka',
                      onAction: widget.onOpenForYou,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 324,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: curatedItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = curatedItems[index];
                          return _CuratedCard(
                            item: item,
                            onTap: () => widget.onOpenDetail(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: 'Jelajahi Topik',
                      subtitle: 'Semua kategori sudah dirapikan agar pengalaman membaca terasa lebih lengkap.',
                      actionLabel: 'Lihat semua',
                      onAction: widget.onOpenCategories,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categoryEntries
                          .map(
                            (entry) => ActionChip(
                              label: Text('${entry.key} • ${entry.value}'),
                              onPressed: widget.onOpenCategories,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionHeader(
                  title: 'Berita Terbaru',
                  subtitle: 'Rangkuman berita terbaru yang tetap nyaman dibaca.',
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

class _TopHeroSection extends StatelessWidget {
  const _TopHeroSection({
    required this.greeting,
    required this.preferenceSummary,
    required this.featuredItems,
    required this.headlineController,
    required this.headlineIndex,
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
          colors: [
            Color(0xFF1D4ED8),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
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
                      const Text(
                        'ZYN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        greeting,
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
                              color: Color(0xFF312E81),
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
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            if (featuredItems.isNotEmpty) ...[
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: headlineController,
                  onPageChanged: onPageChanged,
                  itemCount: featuredItems.length,
                  itemBuilder: (context, index) {
                    final item = featuredItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _HeadlineCard(
                        item: item,
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
              ],
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Belum ada headline yang siap ditampilkan. Coba buka kategori untuk mulai menjelajah berita.',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
              ),
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
    required this.showSwipeHint,
    required this.onTap,
  });

  final NewsItem item;
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
                  colors: [
                    Colors.black.withValues(alpha: 0.06),
                    Colors.black.withValues(alpha: 0.82),
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
                      if (showSwipeHint) ...[
                        const SizedBox(width: 10),
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
                    ],
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
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
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(0, 48),
                        ),
                        child: const Text('Baca sekarang'),
                      ),
                      Text(
                        '${item.readMinutes} menit baca',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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

class _CuratedCard extends StatelessWidget {
  const _CuratedCard({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 264,
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
                height: 124,
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
                        '${item.readMinutes} menit baca',
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
  const _LatestTile({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                width: 104,
                height: 104,
                borderRadius: BorderRadius.circular(18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text('${item.readMinutes} menit baca'),
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
