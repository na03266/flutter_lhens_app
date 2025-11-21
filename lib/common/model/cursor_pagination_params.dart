import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_params.g.dart';

@JsonSerializable()
class CursorPaginationParams {
  final String? cursor;
  final int? take;
  final List<String>? order;

  const CursorPaginationParams({
    this.take,
    this.cursor,
    this.order ,
  });

  CursorPaginationParams copyWith({
    String? cursor,
    List<String>? order,
    int? take,
  }) {
    return CursorPaginationParams(
      cursor: cursor ?? this.cursor,
      order: order ?? this.order,
      take: take ?? this.take,
    );
  }

  factory CursorPaginationParams.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CursorPaginationParamsToJson(this);
}
