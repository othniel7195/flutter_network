/*
 * @Author: jimmy.zhao
 * @Date: 2022-01-13 19:24:39
 * @LastEditTime: 2022-07-26 15:49:16
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
//
//  http_response.dart
//  http_client
//
//  Created by jimmy on 2022/1/14.
//

import 'package:dio/dio.dart';

class HttpJResponse<T> {
  T? data;
  int statusCode;
  String? statusMessage;
  Response response;
  HttpJResponse(
      {this.data, int? statusCode, this.statusMessage, required this.response})
      : statusCode = statusCode ?? 400;

  int get grpcStatusCode {
    final String status = response.headers['grpc-status'] as String;
    return int.tryParse(status) ?? 0;
  }

  String get grpcStatusMessage {
    final String message = response.headers['grpc-message'] as String;
    return Uri.decodeFull(message);
  }
}
