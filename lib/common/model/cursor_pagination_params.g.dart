// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPaginationParams _$CursorPaginationParamsFromJson(
  Map<String, dynamic> json,
) => CursorPaginationParams(
  take: (json['take'] as num?)?.toInt(),
  cursor: json['cursor'] as String?,
  order: (json['order'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CursorPaginationParamsToJson(
  CursorPaginationParams instance,
) => <String, dynamic>{
  'cursor': instance.cursor,
  'take': instance.take,
  'order': instance.order,
};
