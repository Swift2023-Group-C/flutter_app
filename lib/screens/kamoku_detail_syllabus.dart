import 'package:flutter/material.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/repository/kamoku_sort.dart';

class KamokuDetailSyllabusScreen extends StatelessWidget {
  const KamokuDetailSyllabusScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDetails(lessonId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> details = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  ...details.keys.map(
                    (e) {
                      if (details[e] is String) {
                        return _buildRow(e, details[e]);
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            );
          } else {
            return createProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildRow(String title, String? value) {
    if (value == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SelectableText(value),
        const Divider(),
      ],
    );
  }
}
