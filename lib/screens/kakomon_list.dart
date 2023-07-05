import 'package:flutter/material.dart';

class KakomonListScreen extends StatelessWidget {
  const KakomonListScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: const Center(child: Text('過去問', style: TextStyle(fontSize: 32.0))),
    );
  }
}
