import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('マップ')),
      ),
      body: const Center(child: Text('マップ', style: TextStyle(fontSize: 32.0))),
    );
  }
}
