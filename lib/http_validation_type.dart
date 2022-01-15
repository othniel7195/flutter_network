//
//  validation_type.dart
//  http_client
//
//  Created by jimmy on 2022/1/4.
//

class HttpValidationType {
  static List<int> successCodes() {
    List<int> codes = [];
    for (int i = 200; i < 300; i++) {
      codes.add(i);
    }
    return codes;
  }

  static List<int> successAndRedirectCodes() {
    List<int> codes = [];
    for (int i = 200; i < 400; i++) {
      codes.add(i);
    }
    return codes;
  }
}

///自定义codes 需要给customCodes 传值
enum ValidationType { successCodes, successAndRedirectCodes, customCodes }

extension ValidationTypeExt on ValidationType {
  ///自定义codes 需要给customCodes 传值
  List<int> statusCodes({List<int>? customCodes}) {
    switch (this) {
      case ValidationType.successCodes:
        return HttpValidationType.successCodes();
      case ValidationType.successAndRedirectCodes:
        return HttpValidationType.successAndRedirectCodes();
      case ValidationType.customCodes:
        var r = customCodes?.map((e) => e);
        if (r != null) {
          return r.toList();
        }
        return [];
    }
  }
}
