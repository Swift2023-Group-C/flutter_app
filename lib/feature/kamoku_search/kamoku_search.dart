import 'package:dotto/importer.dart';
import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/kamoku_search/domain/kamoku_search_choices.dart';
import 'package:dotto/feature/kamoku_search/widget/kamoku_search_box.dart';
import 'package:dotto/feature/kamoku_search/widget/kamoku_search_filter_checkbox.dart';
import 'package:dotto/feature/kamoku_search/widget/kamoku_search_filter_radio.dart';
import 'package:dotto/feature/kamoku_search/widget/kamoku_search_result.dart';

class KamokuSearchScreen extends ConsumerWidget {
  const KamokuSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final kamokuSearchControllerNotifier =
        ref.watch(kamokuSearchControllerProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: KamokuSearchBox(),
              ),
              Column(
                children: [
                  const KamokuSearchFilterRadio(),
                  ...KamokuSearchChoices.values.map(
                    (e) => Visibility(
                      visible:
                          kamokuSearchController.visibilityStatus.contains(e),
                      child: KamokuSearchFilterCheckbox(
                        kamokuSearchChoices: e,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextButton(
                        onPressed: () {
                          kamokuSearchControllerNotifier.reset();
                        },
                        child: const Text('リセット')),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customFunColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await kamokuSearchControllerNotifier.search();
                      },
                      child: const SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '科目検索',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(
                              Icons.search,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(
                    '結果一覧',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              if (kamokuSearchController.searchResults != null)
                if (kamokuSearchController.searchResults!.isNotEmpty)
                  KamokuSearchResults(
                      records: kamokuSearchController.searchResults!)
                else
                  const Center(
                    child: Text('検索結果は見つかりませんでした'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
