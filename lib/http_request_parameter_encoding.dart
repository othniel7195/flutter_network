//
//  http_request_parameter_encoding.dart
//  http_client
//
//  Created by jimmy on 2022/1/17.
//
import 'package:dio/dio.dart';

import 'http_method.dart';

class HttpRequestParameterEncoding {
  static String encode(HttpMethod method) {
    switch (method) {
      case HttpMethod.get:
        return Headers.formUrlEncodedContentType;
      default:
        return Headers.jsonContentType;
    }
  }
}
