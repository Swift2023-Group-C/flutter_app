import 'package:dotto/feature/my_page/feature/news/repository/news_repository.dart';
import 'package:dotto/importer.dart';

final newsListProvider = FutureProvider((ref) => NewsRepository().getNewsListFromFirestore());
