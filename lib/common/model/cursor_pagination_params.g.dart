// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPaginationParams _$CursorPaginationParamsFromJson(
  Map<String, dynamic> json,
) => CursorPaginationParams(
  count: (json['count'] as num?)?.toInt(),
  after: json['after'] as String?,
);

Map<String, dynamic> _$CursorPaginationParamsToJson(
  CursorPaginationParams instance,
) => <String, dynamic>{'after': instance.after, 'count': instance.count};
