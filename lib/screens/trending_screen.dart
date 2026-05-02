import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({
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
    final sorted = List<NewsItem>.from(news)
      ..sort((a, b) => b.trendingScore.compareTo(a.trendingScore));

    return Scaffold(
      appBar: AppBar(title: const Text('Trending')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = sorted[index];
          final rank = index + 1;
          return Card(
            child: ListTile(
              onTap: () => onOpenDetail(item),
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                child: Text(
                  '#$rank',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${item.category} • score ${item.trendingScore}'),
              ),
              trailing: rank <= 3
                  ? Chip(
                      label: const Text('Top'),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.14),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
