class News {
  final String title;
  final List<String> body;
  final DateTime date;
  final String? imageUrl;

  News(this.title, this.body, this.date, {this.imageUrl});
}
