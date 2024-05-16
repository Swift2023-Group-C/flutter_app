import 'package:dotto/importer.dart';
import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';

class KamokuSearchBox extends ConsumerWidget {
  const KamokuSearchBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final kamokuSearchControllerNotifier =
        ref.watch(kamokuSearchControllerProvider.notifier);
    return TextField(
      controller: kamokuSearchController.textEditingController,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: '科目名を検索',
      ),
      onChanged: (text) {
        kamokuSearchControllerNotifier.setSearchWord(text);
      },
    );
  }
}
