import 'package:flutter/material.dart';

import '../models/news_item.dart';
import '../state/app_controller.dart';
import '../widgets/news_image.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.controller, required this.item});

  final AppController controller;
  final NewsItem item;

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
                onPressed: () => controller.toggleBookmark(item.id),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share action placeholder')),
                  );
                },
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
