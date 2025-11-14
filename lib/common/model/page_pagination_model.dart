import 'package:json_annotation/json_annotation.dart';

part 'page_pagination_model.g.dart';

abstract class PagePaginationBase {}

class PagePaginationError extends PagePaginationBase {
  final String message;

  PagePaginationError({required this.message});
}

class PagePaginationLoading extends PagePaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class PagePagination<T> extends PagePaginationBase {
  final PagePaginationMeta meta;
  final List<T> data;

  PagePagination({required this.meta, required this.data});

  PagePagination copyWith({PagePaginationMeta? meta, List<T>? data}) {
    return PagePagination<T>(meta: meta ?? this.meta, data: data ?? this.data);
  }

  factory PagePagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagePaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class PagePaginationMeta {
  @JsonKey(includeToJson: false)
  final int count; // 전체 데이터 수
  final int take; // 페이지당 데이터 수
  final int page; // 현재 페이지 번호

  PagePaginationMeta({
    required this.count,
    required this.take,
    required this.page,
  });

  PagePaginationMeta copyWith({int? take, int? count, int? page}) {
    return PagePaginationMeta(
      take: take ?? this.take,
      count: count ?? this.count,
      page: page ?? this.page,
    );
  }

  factory PagePaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PagePaginationMetaFromJson(json);
}

// 새로고침할때
class PagePaginationRefetching<T> extends PagePagination<T> {
  PagePaginationRefetching({required super.meta, required super.data});
}

// 리스트 맨 아래로 내려서 추가 데이터를 요청하는 중
class PagePaginationFetchingMore<T> extends PagePagination<T> {
  PagePaginationFetchingMore({required super.meta, required super.data});
}
