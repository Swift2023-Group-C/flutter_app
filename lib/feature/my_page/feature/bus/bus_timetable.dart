import 'package:dotto/feature/my_page/feature/bus/controller/bus_controller.dart';
import 'package:dotto/importer.dart';

class BusTimetableScreen extends ConsumerWidget {
  const BusTimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusStops = ref.watch(allBusStopsProvider);
    final busData = ref.watch(busDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
      ),
      body: allBusStops.when(
        data: (data) => ListView(
          children: data
              .map((e) => ListTile(
                    title: Text(e.name),
                  ))
              .toList(),
        ),
        error: (error, stackTrace) => Column(
          children: [
            Text(error.toString()),
            Text(stackTrace.toString()),
          ],
        ),
        loading: () => Center(
          child: Text("Loading"),
        ),
      ),
    );
  }
}
