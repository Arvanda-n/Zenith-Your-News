import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../models/news_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onOpenDetail});

  final ValueChanged<NewsItem> onOpenDetail;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<String> recent = const [
    'Artificial Intelligence',
    'Green Energy',
    'Minimalist Living',
  ];
  final List<String> trending = const [
    '#Tech (1.2k)',
    '#Economy (800)',
    '#Sports (630)',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = dummyNews.where((n) {
      final q = _query.toLowerCase();
      return n.title.toLowerCase().contains(q) ||
          n.description.toLowerCase().contains(q) ||
          n.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search News')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Cari berita, topik, kategori...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recent Searches',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: recent
                .map(
                  (e) => ActionChip(
                    label: Text(e),
                    onPressed: () => setState(() {
                      _query = e;
                      _controller.text = e;
                    }),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Trending Topics',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: trending.map((e) => Chip(label: Text(e))).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Results', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...result.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  onTap: () => widget.onOpenDetail(item),
                  title: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.category} • ${item.readMinutes} min read',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
