//
//  http_plugin.dart
//  http_client
//
//  Created by jimmy on 2022/1/13.
//

import 'http_target_type.dart';
import 'package:dio/dio.dart';

import 'http_error.dart';
import 'http_response.j.dart';

abstract class HttpPlugin {
  Map<String, dynamic>? get extraParameters => null;

  Future<RequestOptions> beforeCreateRequestOptions(
      {required RequestOptions options, required HttpTargetType type}) {
    return Future.value(options);
  }

  Future<RequestOptions> beforeRequest({required RequestOptions options}) {
    return Future.value(options);
  }

  void didReceive({required HttpJResponse response}) {}

  HttpJResponse process({required HttpJResponse response}) {
    return response;
  }

  void interceptorError({required HttpError error, required ErrorInterceptorHandler handler}) {}

  HttpError processError({required HttpError error, required ErrorInterceptorHandler handler}) {
    return error;
  }
}
