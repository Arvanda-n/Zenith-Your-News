import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../utils/news_category.dart';
import '../widgets/news_image.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.controller,
    required this.item,
    required this.allNews,
    required this.onRequireLogin,
  });

  final AppController controller;
  final NewsItem item;
  final List<NewsItem> allNews;
  final VoidCallback onRequireLogin;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateProgress)
      ..dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final value = max <= 0
        ? 0.0
        : (_scrollController.offset / max).clamp(0.0, 1.0).toDouble();
    if (value != _progress) {
      setState(() => _progress = value);
    }
  }

  void _handleBookmark(BuildContext context) {
    final result = widget.controller.toggleBookmark(widget.item.id);
    final message = switch (result) {
      BookmarkActionResult.added => 'Berita disimpan.',
      BookmarkActionResult.removed => 'Berita dihapus dari simpanan.',
      BookmarkActionResult.loginRequired => 'Silakan masuk terlebih dahulu.',
    };

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    if (result == BookmarkActionResult.loginRequired) {
      widget.onRequireLogin();
    }
  }

  Future<void> _handleShare() async {
    final shareText =
        '${widget.item.title}\n\n${widget.item.description}\n\nOleh ${widget.item.author} | ${_formatDate(widget.item.date)}\n\nBaca di ZYN.';
    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  String _formatDate(DateTime date) {
    const monthNames = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  String _buildInlineCaption() {
    final caption = widget.item.inlineImageHint.trim();
    if (caption.isEmpty) {
      return 'Ilustrasi pendukung berita.';
    }
    return 'Ilustrasi: $caption.';
  }

  @override
  Widget build(BuildContext context) {
    final related = widget.allNews
        .where(
          (news) =>
              news.id != widget.item.id &&
              (news.category == widget.item.category ||
                  news.trendingScore >= 85),
        )
        .take(4)
        .toList();

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final isBookmarked = widget.controller.isBookmarked(widget.item.id);
        final secondaryColor = Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF9AA5C3)
            : const Color(0xFF63708A);
        final paragraphs = widget.item.articleParagraphs.isEmpty
            ? <String>[widget.item.content]
            : widget.item.articleParagraphs;

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 310,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      NewsImage(
                        imageUrl: widget.item.imageUrl,
                        imageHint: widget.item.imageHint,
                        borderRadius: BorderRadius.zero,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withValues(alpha: 0.10),
                              Colors.black.withValues(alpha: 0.82),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.item.categoryLabel,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.16,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.12),
                            child: Text(
                              widget.item.author[0],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.item.location} | ${_formatDate(widget.item.date)} | ${widget.item.readMinutes} menit baca',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          widget.item.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...paragraphs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final paragraph = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paragraph,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 15, height: 1.8),
                            ),
                            const SizedBox(height: 18),
                            if (index == 1) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NewsImage(
                                      imageUrl: widget.item.inlineImageUrl,
                                      imageHint: widget.item.inlineImageHint,
                                      height: 220,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _buildInlineCaption(),
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 13,
                                        height: 1.45,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ],
                        );
                      }),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _handleShare,
                              icon: const Icon(Icons.share_outlined),
                              label: const Text('Bagikan berita'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _handleBookmark(context),
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_add_outlined,
                              ),
                              label: Text(
                                isBookmarked ? 'Tersimpan' : 'Simpan berita',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Berita terkait',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...related.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(
                                      controller: widget.controller,
                                      item: item,
                                      allNews: widget.allNews,
                                      onRequireLogin: widget.onRequireLogin,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    NewsImage(
                                      imageUrl: item.imageUrl,
                                      imageHint: item.imageHint,
                                      width: 96,
                                      height: 96,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.categoryLabel,
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${item.author} | ${item.readMinutes} menit baca',
                                            style: TextStyle(
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'share_story',
                onPressed: _handleShare,
                child: const Icon(Icons.share_outlined),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                heroTag: 'save_story',
                onPressed: () => _handleBookmark(context),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_add_outlined,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
