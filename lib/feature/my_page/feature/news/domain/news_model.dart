class News {
  final String id;
  final String title;
  final List<String> body;
  final DateTime date;
  final String? imageUrl;

  News(this.id, this.title, this.body, this.date, {this.imageUrl});
}
