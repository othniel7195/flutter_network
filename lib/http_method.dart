//
//  http_method.dart
//  http_client
//
//  Created by jimmy on 2022/1/13.
//

class HttpMethod {
  /// `CONNECT` method.
  static const connect = HttpMethod('CONNECT');

  /// `DELETE` method.
  static const delete = HttpMethod("DELETE");

  /// `GET` method.
  static const get = HttpMethod("GET");

  /// `HEAD` method.
  static const head = HttpMethod("HEAD");

  /// `OPTIONS` method.
  static const options = HttpMethod("OPTIONS");

  /// `PATCH` method.
  static const patch = HttpMethod("PATCH");

  /// `POST` method.
  static const post = HttpMethod("POST");

  /// `PUT` method.
  static const put = HttpMethod("PUT");

  /// `TRACE` method.
  static const trace = HttpMethod("TRACE");

  final String rawValue;
  const HttpMethod(this.rawValue);
}
