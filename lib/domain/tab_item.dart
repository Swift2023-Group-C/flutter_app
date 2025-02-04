import 'package:dotto/feature/kamoku_search/kamoku_search.dart';
import 'package:dotto/feature/map/map.dart';
import 'package:dotto/feature/my_page/home.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/screens/kadai_list.dart';
import 'package:dotto/feature/settings/settings.dart';

enum TabItem {
  home(
    title: 'ホーム',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    page: HomeScreen(),
  ),
  map(
    title: 'マップ',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    page: MapScreen(),
  ),
  kamoku(
    title: '科目情報',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
    page: KamokuSearchScreen(),
  ),
  kadai(
    title: '課題',
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
    page: KadaiListScreen(),
  ),
  setting(
    title: '設定',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    page: SettingsScreen(),
  );

  const TabItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });

  // タイトル
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
}

final Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeyMaps = {
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.map: GlobalKey<NavigatorState>(),
  TabItem.kamoku: GlobalKey<NavigatorState>(),
  TabItem.kadai: GlobalKey<NavigatorState>(),
};
