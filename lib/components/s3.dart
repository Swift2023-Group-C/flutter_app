import 'package:minio/minio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minio/models.dart';

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

  Stream<ListObjectsResult> listObjectsV2(
    String bucket, {
    String prefix = '',
    String? startAfter,
  }) async* {
    MinioInvalidBucketNameError.check(bucket);
    MinioInvalidPrefixError.check(prefix);
    final delimiter = '';

    bool? isTruncated = false;
    String? continuationToken;

    do {
      final resp = await _minio!.listObjectsV2Query(
        bucket,
        prefix,
        continuationToken,
        delimiter,
        null,
        startAfter,
      );
      isTruncated = resp.isTruncated;
      continuationToken = resp.nextContinuationToken;
      yield ListObjectsResult(
        objects: resp.contents!,
        prefixes: resp.commonPrefixes.map((e) => e.prefix!).toList(),
      );
    } while (isTruncated!);
  }

  Future<List<String>> getListObjectsKey({required String url}) async {
    instance.getMinio();
    List<String> returnStr = [];
    await for (var value in listObjectsV2('kakomon', prefix: url)) {
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
