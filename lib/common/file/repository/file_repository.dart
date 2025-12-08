import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/file/model/temp_file_model.dart';

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FileRepository(dio);
});

class FileRepository {
  final Dio _dio;

  FileRepository(this._dio);

  Future<TempFileModel> uploadFile({required File file}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _dio.post(
      '$ip/common/file',
      data: formData,

      options: Options(
        headers: {'accessToken': 'true'},  // 토큰 헤더 추가
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    return TempFileModel.fromJson(response.data);
  }

  // 2) 신규: 에디터 이미지 업로드 (bytes 기반)
  Future<String?> uploadEditorImageFromBytes({
    required Uint8List bytes,
    required String filename,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
    });

    final response = await _dio.post(
      '$ip/common/editor',   // Nest @Post('editor') 와 매칭
      data: formData,
      options: Options(
        headers: {'accessToken': 'true'},
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    // Nest에서 { url: '...' }로 반환한다고 가정
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data['url'] as String?;
    }
    // 혹시 문자열로만 돌려줄 경우까지 대비
    if (data is String) {
      return data;
    }

    return null;
  }
}