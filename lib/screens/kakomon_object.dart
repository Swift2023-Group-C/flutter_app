import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/components/s3.dart';
import 'dart:typed_data';
import 'package:flutter_app/components/widgets/progress_indicator.dart';
import 'package:share_plus/share_plus.dart';

class KakomonObjectScreen extends StatefulWidget {
  const KakomonObjectScreen(
      {Key? key, required this.url, required this.filename})
      : super(key: key);
  final String url;
  final String filename;

  @override
  State<KakomonObjectScreen> createState() => _KakomonObjectScreenState();
}

class _KakomonObjectScreenState extends State<KakomonObjectScreen> {
  Uint8List? dataUint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (dataUint != null) {
                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/${widget.filename}';
                File(path).writeAsBytesSync(dataUint as List<int>);
                await Share.shareXFiles([XFile(path)]);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getListObjectsString(),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              return KakomonObjectIfType(url: widget.url, data: snapshot.data!);
            } else {
              return Center(child: createProgressIndicator());
            }
          }),
    );
  }

  Future<Uint8List> getListObjectsString() async {
    final stream = await S3.instance.getObject(url: widget.url);
    List<int> memory = [];

    await for (var value in stream) {
      memory.addAll(value);
    }
    dataUint = Uint8List.fromList(memory);
    return Uint8List.fromList(memory);
  }
}

class KakomonObjectIfType extends StatelessWidget {
  const KakomonObjectIfType({Key? key, required this.url, required this.data})
      : super(key: key);
  final String url;
  final Uint8List data;

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(r'\.(.*)$');
    RegExpMatch? match = exp.firstMatch(url);
    String? filetype = match![1];
    List<String> imageList = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    if (filetype != null) {
      if (filetype.toLowerCase() == 'pdf') {
        return PDFScreen(pdfData: data);
      } else if (imageList.contains(filetype.toLowerCase())) {
        return ImageScreen(imageData: data);
      } else {
        return const Center(child: Text('表示未対応です。右上よりダウンロードできます。'));
      }
    } else {
      return const Center(child: Text('ERROR'));
    }
  }
}

class PDFScreen extends StatefulWidget {
  final Uint8List pdfData;

  const PDFScreen({Key? key, required this.pdfData}) : super(key: key);

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  //final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PDFView(
        pdfData: widget.pdfData,
        enableSwipe: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: currentPage,
        preventLinkNavigation: false,
        autoSpacing: false,
        // 略
      ),
      // 略
    );
  }
}

class ImageScreen extends StatelessWidget {
  final Uint8List imageData;
  const ImageScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image image = Image.memory(imageData);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: InteractiveViewer(maxScale: 10.0, child: image),
    );
  }
}
