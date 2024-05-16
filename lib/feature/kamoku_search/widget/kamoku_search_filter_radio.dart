import 'package:dotto/importer.dart';
import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';

class KamokuSearchFilterRadio extends ConsumerWidget {
  const KamokuSearchFilterRadio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final kamokuSearchControllerNotifier =
        ref.watch(kamokuSearchControllerProvider.notifier);
    return Align(
      alignment: const AlignmentDirectional(-1.00, 0.00),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0;
                i < kamokuSearchControllerNotifier.checkboxSenmonKyoyo.length;
                i++)
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Radio(
                      value: i,
                      onChanged: (value) {
                        kamokuSearchControllerNotifier.radioOnChanged(value);
                      },
                      groupValue: kamokuSearchController.senmonKyoyoStatus,
                    ),
                    Text(kamokuSearchControllerNotifier.checkboxSenmonKyoyo[i]),
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
