import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ホーム')),
      ),
      body: const Center(child: Text('ホーム', style: TextStyle(fontSize: 32.0))),
    );
  }
}
