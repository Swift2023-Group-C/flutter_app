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
      body: allBusStop != null
          ? ListView(
              children: allBusStop
                  .where((busStop) => busStop.selectable != false)
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
            )
          : createProgressIndicator(),
    );
  }
}
