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
}
