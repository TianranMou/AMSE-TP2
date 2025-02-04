class MediaItem {
  final String id;
  final String title;
  final String type;
  final String description;
  bool isLiked;

  MediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    this.isLiked = false,
  });
}