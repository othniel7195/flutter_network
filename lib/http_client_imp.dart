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
import 'http_method.dart';
import 'package:dio/adapter.dart';
import 'dart:io';

class HttpClient {
  HttpClient();
  void setup(String? proxyUri) {
    _dio = Dio();
    _middleware = HttpMiddleware();
    _dio.interceptors.add(_middleware);
    if (kDebugMode) {
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
    _dio.httpClientAdapter = DefaultHttpClientAdapter();
    setProxyUri = proxyUri;
  }

  late Dio _dio;
  late HttpMiddleware _middleware;

  set setProxyUri(String? uri) {
    if (uri == null) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          null;
    } else {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (c) {
        c.findProxy = (u) {
          return "PROXY $uri";
        };
        c.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<dynamic> request<T>(
      {required HttpDataTargetType targetType, custom}) async {
    RequestOptions options = _createRequestOptions(targetType: targetType);
    Response<T> response = await _dio.fetch<T>(options);
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
    final path = targetType.path;
    if (path.startsWith("/")) {
      path.replaceFirst("/", "");
    }
    RequestOptions options = RequestOptions(path: path);
    options.connectTimeout = targetType.timeoutInterval;
    if (!targetType.baseUrl.endsWith("/")) {
      options.baseUrl = targetType.baseUrl + '/';
    }
    options.method = targetType.method.rawValue;

    options.headers = _createHeaders(targetType: targetType);
    options.contentType =
        HttpRequestParameterEncoding.encode(targetType.method);

    if (targetType.parameters != null) {
      switch (targetType.method) {
        case HttpMethod.get:
          options.queryParameters = targetType.parameters!;
          break;
        default:
          options.data = targetType.parameters!;
          break;
      }
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
