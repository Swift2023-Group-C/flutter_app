class News {
  final String id;
  final String title;
  final List<String> body;
  final DateTime date;
  final bool image;

  News(this.id, this.title, this.body, this.date, {this.image = false});
}
