import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/user/model/change_password_dto.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/dio/dio.dart';
import '../model/user_model.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(dio, baseUrl: '$ip/user');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/me')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @PATCH('/password')
  @Headers({'accessToken': 'true'})
  Future<void> changePassword({@Body() required ChangePasswordDto dto});
}
