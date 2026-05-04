import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.controller,
    required this.item,
    required this.allNews,
  });

  final AppController controller;
  final NewsItem item;
  final List<NewsItem> allNews;

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
      BookmarkActionResult.loginRequired =>
        'Masuk dulu untuk menyimpan berita.',
    };

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleShare() async {
    final shareText =
        '${widget.item.title}\n\n${widget.item.description}\n\nKategori: ${widget.item.category} • ${widget.item.readMinutes} min read\n\nBaca di ZYN.';
    await SharePlus.instance.share(ShareParams(text: shareText));
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

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 280,
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
                                colors: [
                                  Colors.black.withValues(alpha: 0.08),
                                  Colors.black.withValues(alpha: 0.78),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              widget.item.category,
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
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.item.readMinutes} menit baca • Progres baca ${(100 * _progress).round()}%',
                            style: TextStyle(color: secondaryColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.item.content,
                            style: const TextStyle(fontSize: 17, height: 1.8),
                          ),
                          const SizedBox(height: 28),
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
                                          width: 90,
                                          height: 90,
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.category,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
