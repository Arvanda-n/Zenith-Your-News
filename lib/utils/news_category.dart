import '../models/news_item.dart';

const Map<String, String> _categoryLabels = <String, String>{
  'technology': 'Teknologi',
  'economy': 'Ekonomi',
  'urban': 'Perkotaan',
  'lifestyle': 'Gaya Hidup',
  'education': 'Pendidikan',
  'sports': 'Olahraga',
  'innovation': 'Inovasi',
  'travel': 'Wisata',
  'business': 'Bisnis',
  'health': 'Kesehatan',
};

extension NewsItemCategoryX on NewsItem {
  String get categoryLabel {
    final normalized = category.trim().toLowerCase();
    return _categoryLabels[normalized] ?? category;
  }
}
