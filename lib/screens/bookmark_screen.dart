import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({
    super.key,
    required this.controller,
    required this.news,
    required this.onOpenDetail,
  });

  final AppController controller;
  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final bookmarked = news
            .where((n) => controller.isBookmarked(n.id))
            .toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Bookmarks')),
          body: bookmarked.isEmpty
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
                        onTap: () => onOpenDetail(item),
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
