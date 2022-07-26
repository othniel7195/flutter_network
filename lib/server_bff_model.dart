/*
 * @Author: jimmy.zhao
 * @Date: 2022-07-26 15:41:09
 * @LastEditTime: 2022-07-26 16:22:55
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
import 'package:json_annotation/json_annotation.dart';
part 'server_bff_model.g.dart';

@JsonSerializable()
class SeverBffModel {
  @JsonKey(defaultValue: 0)
  final int code;
  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: {})
  final Map<String, dynamic> data;
  SeverBffModel(
      {required this.code, required this.message, required this.data});
  factory SeverBffModel.fromJson(Map<String, dynamic> json) =>
      _$SeverBffModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeverBffModelToJson(this);
}
