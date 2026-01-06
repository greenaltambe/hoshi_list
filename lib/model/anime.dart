class Anime {
  Anime({required this.title, required this.imageUrl})
    : id = DateTime.now().toIso8601String();

  final String id;
  final String title;
  final String imageUrl;
}
