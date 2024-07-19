import 'package:dotto/app/domain/tab_item.dart';
import 'package:dotto/importer.dart';

final tabItemProvider = NotifierProvider<TabNotifier, TabItem>(() {
  return TabNotifier();
});

class TabNotifier extends Notifier<TabItem> {
  @override
  TabItem build() {
    return TabItem.home;
  }

  void selected(TabItem selectedTab) {
    // 同じタブを押すと一番上に戻る
    if (state == selectedTab) {
      final navigatorKey = tabNavigatorKeyMaps[selectedTab];
      if (navigatorKey != null) {
        final currentState = navigatorKey.currentState;
        if (currentState != null) {
          currentState.popUntil((route) => route.isFirst);
        }
      }
    } else {
      state = selectedTab;
    }
  }
}
