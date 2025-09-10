import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';

import '../../common/dio/dio.dart';
import '../model/user_model.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(baseUrl: '$ip/userMe', dio: dio);
});

class UserMeRepository {
  final String baseUrl;
  final Dio dio;

  UserMeRepository({required this.baseUrl, required this.dio});

  Future<UserModel> getMe() async {
    return UserModel(mbId: '', mbName: '');
  }

  // Future<TokenResponse> token() async {
  //   final resp = await dio.post(
  //     '$baseUrl/token',
  //     options: Options(
  //       headers: {
  //         'refreshToken': 'true',
  //       },
  //     ),
  //   );
  //   return TokenResponse.fromJson(resp.data);
  // }
}
