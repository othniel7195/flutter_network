//
//  http_access_token_authorizable.dart
//  http_client
//
//  Created by jimmy on 2022/1/13.
//

import 'http_target_type.dart';
import 'package:dio/dio.dart';

import 'http_plugin.dart';

enum AuthorizationType { none, basic, bearer }

mixin AccessTokenAuthorizable {
  AuthorizationType get authorizationType => AuthorizationType.bearer;
}

extension AuthorizationTypeExt on AuthorizationType {
  String? get value {
    switch (this) {
      case AuthorizationType.basic:
        return "Basic";
      case AuthorizationType.bearer:
        return "Bearer";
      case AuthorizationType.none:
        return null;
    }
  }
}

class AccessTokenPlugin extends HttpPlugin {
  final String token;
  AccessTokenPlugin({required this.token});
  @override
  RequestOptions beforeCreateRequestOptions(
      {required RequestOptions options, required HttpTargetType type}) {
    AccessTokenAuthorizable at = type as AccessTokenAuthorizable;
    AuthorizationType atT = at.authorizationType;
    if (atT.value != null) {
      options.headers['authorization'] = "${atT.value} $token";
    }
    return options;
  }
}
