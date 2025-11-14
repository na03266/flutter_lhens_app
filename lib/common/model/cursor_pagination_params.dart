import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_params.g.dart';

@JsonSerializable()
class CursorPaginationParams {
  final String? after;
  final int? count;

  const CursorPaginationParams({this.count, this.after});

  CursorPaginationParams copyWith({String? after, int? count}) {
    return CursorPaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory CursorPaginationParams.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CursorPaginationParamsToJson(this);
}
