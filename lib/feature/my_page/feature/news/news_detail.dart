import 'package:dotto/feature/my_page/feature/news/domain/news_model.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;
  const NewsDetailScreen(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy年M月d日 HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dottoからのお知らせ"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatter.format(news.date),
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Wrap(
              // direction: Axis.vertical,
              runSpacing: 10,
              children: news.body
                  .map((e) => Text(
                        e,
                        style: const TextStyle(letterSpacing: 0.5),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
