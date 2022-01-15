//
//  http_target_type.dart
//  http_client
//
//  Created by jimmy on 2022/1/17.
//

import 'http_method.dart';

import 'http_validation_type.dart';

abstract class HttpTargetType {
  ValidationType get validation => ValidationType.successCodes;
  HttpMethod get method => HttpMethod.post;
  Map<String, dynamic>? get parameters => null;
  Map<String, dynamic>? get headers => null;
  int get timeoutInterval => 10000;

  ///如果 validation == ValidationType.customCodes
  ///customCodes 不能为空
  List<int>? get customCodes => null;
}

abstract class HttpDataTargetType extends HttpTargetType {
  String get baseUrl;
  String get path;
}
