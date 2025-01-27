import 'package:dotto/feature/my_page/feature/news/domain/news_model.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/download_file_from_firebase.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;
  const NewsDetailScreen(this.news, {super.key});

  Future<Image?> _getNewsImage() async {
    if (news.image) {
      final data = await getFileFromFirebase("news/${news.id}.png");
      if (data != null) {
        return Image.memory(data);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy年M月d日 HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dottoからのお知らせ"),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              if (news.image)
                FutureBuilder(
                  future: _getNewsImage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data != null) {
                        return data;
                      }
                    }
                    return Container();
                  },
                ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: news.body
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            e,
                            style: const TextStyle(letterSpacing: 0.5),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
