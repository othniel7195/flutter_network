/*
 * @Author: jimmy.zhao
 * @Date: 2022-07-26 15:41:49
 * @LastEditTime: 2022-07-26 16:23:02
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
part of 'server_bff_model.dart';

SeverBffModel _$SeverBffModelFromJson<T>(Map<String, dynamic> json) =>
    SeverBffModel(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );

Map<String, dynamic> _$SeverBffModelToJson(SeverBffModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
