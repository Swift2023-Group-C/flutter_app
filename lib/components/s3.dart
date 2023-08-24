import 'package:minio_new/minio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class S3 {
  Minio? _minio;
  S3._();

  static final instance = S3._();
  Minio getMinio() {
    _minio ??= Minio(
      endPoint: dotenv.env['END_POINT']!,
      accessKey: dotenv.env['ACCESS_KEY']!,
      secretKey: dotenv.env['SECRET_KEY']!,
      useSSL: true,
    );
    return _minio!;
  }

  Future<List<String>> getListObjectsKey({required String url}) async {
    instance.getMinio();
    List<String> returnStr = [];
    await for (var value
        in _minio!.listObjectsV2('kakomon', prefix: url, recursive: true)) {
      for (var obj in value.objects) {
        returnStr.add(obj.key!);
      }
    }
    return returnStr;
  }

  Future<MinioByteStream> getObject({required String url}) async {
    instance.getMinio();
    return _minio!.getObject('kakomon', url);
  }
}
