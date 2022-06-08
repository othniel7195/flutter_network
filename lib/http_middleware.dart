//
//  http_middleware.dart
//  http_client
//
//  Created by jimmy on 2022/1/14.
//

import 'http_error.dart';
import 'http_response.j.dart';
import 'package:dio/dio.dart';
import 'http_plugin.dart';

class HttpMiddleware extends Interceptor {
  List<HttpPlugin>? _plugins;
  HttpMiddleware() {
    _plugins = [];
  }
  void addPlugin(HttpPlugin plugin) {
    _plugins?.add(plugin);
  }

  void removePlugin(HttpPlugin plugin) {
    _plugins?.remove(plugin);
  }

  List<HttpPlugin>? getAll() {
    return _plugins;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    RequestOptions requestOptions = options;
    if (_plugins != null) {
      for (var plugin in _plugins!) {
        requestOptions = await plugin.beforeRequest(options: requestOptions);
      }
    }
    super.onRequest(requestOptions, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    HttpJResponse res = HttpJResponse(
        data: response.data,
        statusMessage: response.statusMessage,
        statusCode: response.statusCode,
        response: response);
    if (_plugins != null) {
      for (var plugin in _plugins!) {
        plugin.didReceive(response: res);
        res = plugin.process(response: res);
      }
    }
    super.onResponse(res.response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    HttpError error = HttpError(dioError: err);
    if (_plugins != null) {
      for (var plugin in _plugins!) {
        plugin.interceptorError(error: error, handler: handler);
        error = plugin.processError(error: error, handler: handler);
      }
    }
    super.onError(error.dioError, handler);
  }
}
