class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.date,
    required this.readMinutes,
    required this.imageHint,
    required this.imageUrl,
    this.featured = false,
    this.trendingScore = 0,
  });

  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final DateTime date;
  final int readMinutes;
  final String imageHint;
  final String imageUrl;
  final bool featured;
  final int trendingScore;
}
