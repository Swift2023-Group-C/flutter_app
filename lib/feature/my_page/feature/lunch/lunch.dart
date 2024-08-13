import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LunchScreen extends StatelessWidget {
  const LunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("学食メニュー"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop("back");
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: firebase_storage.FirebaseStorage.instance.ref('home/lunch.jpg').getDownloadURL(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading image');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
