import 'package:json_annotation/json_annotation.dart';

part 'page_pagination_params.g.dart';

@JsonSerializable()
class PagePaginationParams {
  final int? page;
  final int? take;
  final String? caName;
  final String? wr1;
  final String? title;

  const PagePaginationParams({
    this.take,
    this.page,
    this.caName,
    this.wr1,
    this.title,
  });

  PagePaginationParams copyWith({
    int? page,
    int? take,
    String? caName,
    String? wr1,
    String? title,
  }) {
    return PagePaginationParams(
      page: page ?? this.page,
      take: take ?? this.take,
      caName: caName ?? this.caName,
      wr1: wr1 ?? this.wr1,
      title: title ?? this.title,
    );
  }

  factory PagePaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PagePaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PagePaginationParamsToJson(this);
}
