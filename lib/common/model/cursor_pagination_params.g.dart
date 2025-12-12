// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPaginationParams _$CursorPaginationParamsFromJson(
  Map<String, dynamic> json,
) => CursorPaginationParams(
  take: (json['take'] as num?)?.toInt(),
  name: json['name'] as String?,
  cursor: json['cursor'] as String?,
  order: (json['order'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CursorPaginationParamsToJson(
  CursorPaginationParams instance,
) => <String, dynamic>{
  if (instance.cursor case final value?) 'cursor': value,
  if (instance.name case final value?) 'name': value,
  if (instance.take case final value?) 'take': value,
  if (instance.order case final value?) 'order': value,
};
