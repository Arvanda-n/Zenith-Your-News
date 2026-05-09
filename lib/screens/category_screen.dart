import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../theme/app_theme.dart';
import '../utils/news_category.dart';
import '../widgets/news_image.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.news,
    required this.onOpenDetail,
    this.initialCategory,
  });

  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;
  final String? initialCategory;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory?.trim().isNotEmpty == true
        ? widget.initialCategory!.trim()
        : 'Semua';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = <String>{
      'Semua',
      ...widget.news.map((item) => item.categoryLabel),
    }.toList();

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = 'Semua';
    }

    final filtered = _selectedCategory == 'Semua'
        ? widget.news
        : widget.news
              .where((item) => item.categoryLabel == _selectedCategory)
              .toList();
    final highlighted = filtered.isNotEmpty ? filtered.first : null;
    final remaining = filtered.length > 1
        ? filtered.skip(1).toList()
        : const [];
    final selectedIcon =
        _topicIcons[_selectedCategory] ?? Icons.newspaper_rounded;
    final selectedAccent =
        _topicAccents[_selectedCategory] ?? AppTheme.secondary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Jelajahi Topik',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CategoryHeroCard(
                      selectedCategory: _selectedCategory,
                      articleCount: filtered.length,
                      icon: selectedIcon,
                      accentColor: selectedAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Pilih topik',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kurasi berita yang paling relevan untuk ritme baca Anda.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppTheme.darkSecondaryText
                            : AppTheme.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final selected = category == _selectedCategory;
                    final icon =
                        _topicIcons[category] ?? Icons.newspaper_rounded;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        avatar: Icon(
                          icon,
                          size: 18,
                          color: selected
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                        label: Text(category),
                        selected: selected,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                          fontWeight: FontWeight.w700,
                        ),
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white,
                        selectedColor: theme.colorScheme.primary,
                        side: BorderSide(
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          if (highlighted != null) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sorotan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${filtered.length} artikel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkSecondaryText
                            : AppTheme.lightSecondaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: _FeaturedCategoryCard(
                  item: highlighted,
                  onTap: () => widget.onOpenDetail(highlighted),
                ),
              ),
            ),
          ] else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _EmptyCategoryState(category: _selectedCategory),
              ),
            ),
          if (remaining.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Text(
                  'Lanjutan bacaan',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            sliver: SliverList.builder(
              itemCount: remaining.length,
              itemBuilder: (context, index) {
                final item = remaining[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CategoryNewsTile(
                    item: item,
                    onTap: () => widget.onOpenDetail(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeroCard extends StatelessWidget {
  const _CategoryHeroCard({
    required this.selectedCategory,
    required this.articleCount,
    required this.icon,
    required this.accentColor,
  });

  final String selectedCategory;
  final int articleCount;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF081A3A), AppTheme.primary, accentColor],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF081A3A).withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 18),
            Text(
              selectedCategory == 'Semua'
                  ? 'Semua topik dalam satu alur'
                  : 'Topik $selectedCategory untuk Anda',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedCategory == 'Semua'
                  ? 'Lihat rangkuman lintas kategori dengan susunan yang lebih fokus dan nyaman dibaca.'
                  : 'Temukan berita pilihan, cerita utama, dan update terbaru pada topik yang sedang Anda ikuti.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                articleCount == 0
                    ? 'Belum ada artikel tersedia'
                    : '$articleCount artikel siap dibaca',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCategoryCard extends StatelessWidget {
  const _FeaturedCategoryCard({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.4,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NewsImage(
                  imageUrl: item.imageUrl,
                  imageHint: item.imageHint,
                  height: 248,
                  width: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.58),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.categoryLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              height: 1.12,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.readMinutes} menit baca',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
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

class _CategoryNewsTile extends StatelessWidget {
  const _CategoryNewsTile({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                width: 104,
                height: 112,
                borderRadius: BorderRadius.circular(20),
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
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${item.author} | ${item.readMinutes} menit baca',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.inbox_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada artikel untuk $category',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba pilih topik lain untuk melihat lebih banyak berita yang tersedia.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const Map<String, IconData> _topicIcons = <String, IconData>{
  'Semua': Icons.auto_awesome_rounded,
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

const Map<String, Color> _topicAccents = <String, Color>{
  'Semua': AppTheme.secondary,
  'Teknologi': Color(0xFF18B6FF),
  'Ekonomi': Color(0xFF22C55E),
  'Perkotaan': Color(0xFF3B82F6),
  'Gaya Hidup': Color(0xFFF97316),
  'Pendidikan': Color(0xFF8B5CF6),
  'Olahraga': Color(0xFFE11D48),
  'Inovasi': Color(0xFF14B8A6),
  'Wisata': Color(0xFF06B6D4),
  'Bisnis': Color(0xFF0EA5E9),
  'Kesehatan': Color(0xFFEF4444),
};
