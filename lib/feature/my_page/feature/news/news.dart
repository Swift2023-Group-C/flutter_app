import 'package:dotto/feature/my_page/feature/news/widget/news_list.dart';
import 'package:dotto/importer.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dottoからのお知らせ"),
      ),
      body: const NewsList(),
    );
  }
}
