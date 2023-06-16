import 'package:flutter/material.dart';

class KakomonScreen extends StatelessWidget {
  const KakomonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('過去問')),
      ),
      body: const Center(child: Text('過去問', style: TextStyle(fontSize: 32.0))),
    );
  }
}
