import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:retrofit/retrofit.dart';

part 'board_repository.g.dart';

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BoardRepository(dio, baseUrl: '$ip/board');
});

@RestApi()
abstract class BoardRepository {
  factory BoardRepository(Dio dio, {String baseUrl}) = _BoardRepository;


  @GET('')
  @Headers({'accessToken': 'true'})
  Future<BoardInfo> getBoard();
}
