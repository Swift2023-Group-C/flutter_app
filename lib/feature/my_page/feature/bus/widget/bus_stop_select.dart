import 'package:dotto/components/setting_user_info.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/importer.dart';

class BusStopSelectScreen extends ConsumerWidget {
  const BusStopSelectScreen({super.key});

  Future<void> setMyBusStop(int id) async {
    await UserPreferences.setInt(UserPreferenceKeys.myBusStop, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusStop = ref.watch(allBusStopsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("バス停選択"),
      ),
      body: allBusStop.when(
        data: (allBusStops) {
          final selectableBusStops = allBusStops.where((busStop) => busStop.selectable != false);
          return ListView(
            children: selectableBusStops
                .map(
                  (e) => ListTile(
                    onTap: () async {
                      final myBusStopNotifier = ref.read(myBusStopProvider.notifier);
                      await UserPreferences.setInt(UserPreferenceKeys.myBusStop, e.id);
                      myBusStopNotifier.set(e);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    title: Text(e.name),
                  ),
                )
                .toList(),
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text("エラーが発生しました。¥nアプリを再起動してください。"),
          );
        },
        loading: () => Center(
          child: createProgressIndicator(),
        ),
      ),
    );
  }
}
