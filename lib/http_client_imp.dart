//
//  http_client_imp.dart
//  http_client
//
//  Created by jimmy on 2022/1/17.
//

import 'http_plugin.dart';
import 'http_request_parameter_encoding.dart';
import 'http_response.j.dart';
import 'http_target_type.dart';
import 'http_validation_type.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'http_middleware.dart';

class HttpClient {
  factory HttpClient() => _instance;
  static late final HttpClient _instance = HttpClient._internal();
  HttpClient._internal() {
    setup();
  }
  void setup() {
    _dio = Dio();
    _middleware = HttpMiddleware();
    _dio.interceptors.add(_middleware);
    if (kDebugMode) {
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
    _dio.httpClientAdapter = Http2Adapter(
      ConnectionManager(),
    );
  }

  late Dio _dio;
  late HttpMiddleware _middleware;

  Future<HttpJResponse<T>> request<T>(
      {required HttpDataTargetType targetType, custom}) async {
    RequestOptions options = _createRequestOptions(targetType: targetType);
    Response<T> response = await _dio.fetch(options);

    return HttpJResponse<T>(
        response: response,
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage);
  }

  void addPlugin({required HttpPlugin plugin}) {
    _middleware.addPlugin(plugin);
  }

  void removePlugin({required HttpPlugin plugin}) {
    _middleware.removePlugin(plugin);
  }

  RequestOptions _createRequestOptions(
      {required HttpDataTargetType targetType}) {
    RequestOptions options = RequestOptions(path: targetType.path);
    options.connectTimeout = targetType.timeoutInterval;
    options.baseUrl = targetType.baseUrl;
    options.method = targetType.method.rawValue;

    options.headers = _createHeaders(targetType: targetType);
    options.contentType =
        HttpRequestParameterEncoding.encode(targetType.method);

    if (targetType.parameters != null) {
      options.queryParameters = targetType.parameters!;
    }

    options.validateStatus = (int? status) {
      return _checkStatusCode(targetType: targetType, statusCode: status);
    };
    _middleware.getAll()?.forEach(
      (e) {
        options =
            e.beforeCreateRequestOptions(options: options, type: targetType);
      },
    );
    return options;
  }

  bool _checkStatusCode(
      {required HttpDataTargetType targetType, int? statusCode}) {
    if (statusCode != null) {
      ValidationType vt = targetType.validation;
      if (vt
          .statusCodes(customCodes: targetType.customCodes)
          .contains(statusCode)) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> _createHeaders(
      {required HttpDataTargetType targetType}) {
    Map<String, dynamic> headers = {};
    targetType.headers?.forEach((key, value) {
      headers[key] = value;
    });
    return headers;
  }
}
