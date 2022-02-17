/*
 * @Author: jimmy.zhao
 * @Date: 2022-01-13 19:24:39
 * @LastEditTime: 2022-02-16 18:04:12
 * @LastEditors: jimmy.zhao
 * @Description: 
 * 
 * 
 */
//
//  http_error.dart
//  http_client
//
//  Created by jimmy on 2022/1/13.
//

import 'package:dio/dio.dart';

class HttpError {
  DioError dioError;
  dynamic error;
  HttpError({this.error, required this.dioError});

  int get grpcStatusCode {
    final String status = dioError.response?.headers['grpc-status'] as String;
    return int.tryParse(status) ?? 0;
  }

  String get grpcStatusMessage {
    final String message = dioError.response?.headers['grpc-message'] as String;
    return Uri.decodeFull(message);
  }

  String get dioErrorMessage {
    return dioError.message;
  }

  String get serverMessage {
    if (dioError.response?.data != null) {
      final Map<String, dynamic> dict = dioError.response!.data;
      String message = dict['message'];
      return message;
    }
    return '';
  }

  int get serverCode {
    if (dioError.response?.data != null) {
      final Map<String, dynamic> dict = dioError.response!.data;
      int code = dict['code'];
      return code;
    }
    return -1;
  }
}
