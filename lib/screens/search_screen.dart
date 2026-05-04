import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../widgets/news_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.news,
    required this.onOpenDetail,
  });

  final List<NewsItem> news;
  final ValueChanged<NewsItem> onOpenDetail;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trendingTopics = widget.news
        .map((item) => item.category)
        .toSet()
        .take(6)
        .toList();
    final result = widget.news.where((n) {
      final q = _query.toLowerCase();
      return n.title.toLowerCase().contains(q) ||
          n.description.toLowerCase().contains(q) ||
          n.category.toLowerCase().contains(q);
    }).toList();
    final recommendations = List<NewsItem>.from(widget.news)
      ..sort((a, b) => b.trendingScore.compareTo(a.trendingScore));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Cari berita, topik, kategori...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _query.isEmpty ? 'Sedang populer' : 'Hasil pencarian',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (_query.isEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: trendingTopics
                    .map(
                      (topic) => ActionChip(
                        label: Text(topic),
                        onPressed: () {
                          _controller.text = topic;
                          setState(() => _query = topic);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Rekomendasi untuk dijelajahi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...recommendations.take(5).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => widget.onOpenDetail(item),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            NewsImage(
                              imageUrl: item.imageUrl,
                              imageHint: item.imageHint,
                              width: 92,
                              height: 92,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.category,
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
            ] else if (result.isEmpty) ...[
              const SizedBox(height: 24),
              const Center(
                child: Text('Belum ada hasil yang cocok. Coba kata kunci lain.'),
              ),
            ] else ...[
              const SizedBox(height: 8),
              ...result.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      minLeadingWidth: 86,
                      leading: NewsImage(
                        imageUrl: item.imageUrl,
                        imageHint: item.imageHint,
                        width: 86,
                        height: 86,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${item.category} • ${item.readMinutes} menit baca',
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => widget.onOpenDetail(item),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
