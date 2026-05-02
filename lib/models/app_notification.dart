class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.newsId,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? newsId;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      newsId: newsId,
      isRead: isRead ?? this.isRead,
    );
  }
}
