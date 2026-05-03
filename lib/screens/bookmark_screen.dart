import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({
    super.key,
    required this.controller,
    required this.news,
    required this.onOpenDetail,
    required this.onOpenLogin,
  });

  final AppController controller;
  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;
  final VoidCallback onOpenLogin;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final bookmarked = news.where((n) => controller.isBookmarked(n.id)).toList();
        final isLoggedIn = controller.isLoggedIn;

        return Scaffold(
          appBar: AppBar(title: const Text('Bookmarks')),
          body: !isLoggedIn
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 56),
                        const SizedBox(height: 12),
                        const Text(
                          'Login untuk memakai bookmark',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Bookmark hanya disimpan untuk pengguna yang sudah login.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: onOpenLogin,
                          child: const Text('Login sekarang'),
                        ),
                      ],
                    ),
                  ),
                )
              : bookmarked.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bookmark_border, size: 56),
                        SizedBox(height: 12),
                        Text(
                          'No bookmarks yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text('Simpan berita untuk dibaca nanti.'),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookmarked.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = bookmarked[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        minLeadingWidth: 72,
                        onTap: () => onOpenDetail(item),
                        leading: NewsImage(
                          imageUrl: item.imageUrl,
                          imageHint: item.imageHint,
                          width: 72,
                          height: 72,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${item.category} • ${item.readMinutes} min read',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.removeBookmark(item.id),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
