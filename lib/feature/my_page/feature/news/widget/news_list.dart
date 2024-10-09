import 'package:dotto/components/animation.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/news/controller/news_controller.dart';
import 'package:dotto/feature/my_page/feature/news/news_detail.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class NewsList extends ConsumerWidget {
  final bool isHome; // Trueなら3つ
  const NewsList({this.isHome = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsList = ref.watch(newsListProvider);
    final formatter = DateFormat('yyyy年M月d日 HH:mm');
    if (newsList != null) {
      return ListView.separated(
        physics: isHome ? const NeverScrollableScrollPhysics() : null,
        itemCount: isHome && newsList.length > 3 ? 3 : newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return ListTile(
            title: Text(
              news.title,
              style: TextStyle(fontSize: isHome ? 14 : null),
            ),
            subtitle: Text(
              formatter.format(news.date),
              style: TextStyle(fontSize: isHome ? 10 : 12),
            ),
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => NewsDetailScreen(news),
                transitionsBuilder: fromRightAnimation,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_outlined),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 0,
        ),
        shrinkWrap: isHome,
      );
    }
    return createProgressIndicator();
  }
}
