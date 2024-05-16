import 'package:dotto/importer.dart';
import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/kamoku_search/domain/kamoku_search_choices.dart';

class KamokuSearchFilterCheckbox extends ConsumerWidget {
  const KamokuSearchFilterCheckbox(
      {super.key, required this.kamokuSearchChoices});

  final KamokuSearchChoices kamokuSearchChoices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final kamokuSearchControllerNotifier =
        ref.watch(kamokuSearchControllerProvider.notifier);
    final checkedList =
        kamokuSearchController.checkboxStatusMap[kamokuSearchChoices]!;
    return Align(
      alignment: const AlignmentDirectional(-1.00, 0.00),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < kamokuSearchChoices.choice.length; i++)
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Checkbox(
                      value: checkedList[i],
                      onChanged: (value) {
                        kamokuSearchControllerNotifier.checkboxOnChanged(
                            value, kamokuSearchChoices, i);
                      },
                    ),
                    Text(kamokuSearchChoices.displayString?[i] ??
                        kamokuSearchChoices.choice[i]),
                  ],
                ),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
