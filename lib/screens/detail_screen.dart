import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.controller, required this.item});

  final AppController controller;
  final NewsItem item;

  void _handleBookmark(BuildContext context) {
    final result = controller.toggleBookmark(item.id);
    final message = switch (result) {
      BookmarkActionResult.added => 'Berita disimpan ke bookmark.',
      BookmarkActionResult.removed => 'Berita dihapus dari bookmark.',
      BookmarkActionResult.loginRequired =>
        'Login dulu untuk menyimpan bookmark.',
    };

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleShare() async {
    final shareText =
        '${item.title}\n\n${item.description}\n\nKategori: ${item.category} • ${item.readMinutes} min read\n\nBaca di ZYN.';
    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isBookmarked = controller.isBookmarked(item.id);
        final secondaryColor = Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFA4A4A4)
            : const Color(0xFF6B7280);

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () => _handleBookmark(context),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: _handleShare,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              NewsImage(
                imageUrl: item.imageUrl,
                imageHint: item.imageHint,
                height: 220,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${item.category} • ${item.readMinutes} min read',
                style: TextStyle(color: secondaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                item.content,
                style: const TextStyle(fontSize: 16, height: 1.65),
              ),
            ],
          ),
        );
      },
    );
  }
}
