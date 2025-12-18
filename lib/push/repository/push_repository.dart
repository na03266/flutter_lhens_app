import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';

final pushRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return PushRepository(dio: dio);
});

class PushRepository {
  final Dio dio;
  PushRepository({required this.dio});

  Future<void> registerToken({
    required String platform, // "android" | "ios"
    String? deviceId,
    String? appVersion,
    bool optIn = true,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return;

    await dio.post(
      '$ip/push/register',
      data: {
        'token': token,
        'platform': platform,
        'deviceId': deviceId,
        'appVersion': appVersion,
        'optIn': optIn,
      },
      options: Options(
        headers: {'accessToken': 'true'}, // ✅ 여기!
      ),
    );
  }

  Future<void> subscribeTopic({required String topic}) async {
    await dio.post(
      '$ip/push/subscribe/$topic',
      options: Options(headers: {'accessToken': 'true'}),
    );
  }
}
