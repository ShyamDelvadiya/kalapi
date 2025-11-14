class BaseResponse {
  BaseResponse({
    bool? success,
    String? message,
    dynamic data,
    List<Error>? errors,
  }) {
    _success = success;
    _message = message;
    _data = data;
    _error = errors;
  }

  bool? _success;
  String? _message;
  dynamic _data;
  List<Error>? _error;

  bool? get success => _success;
  String? get message => _message;
  dynamic get data => _data;
  List<Error>? get error => _error;

  BaseResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'];

    if (json['errors'] != null) {
      _error = [];
      json['errors'].forEach((v) {
        _error?.add(Error.fromJson(v));
      });
    } else if (json['error'] != null) {
      if (json['error'] is List) {
        _error = List<Error>.from(
          json['error'].map((e) => Error(message: e.toString())),
        );
      } else if (json['error'] is String) {
        _error = [Error(message: json['error'])];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['data'] = _data;
    if (_error != null) {
      map['errors'] = _error?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Error {
  Error({String? message}) {
    _message = message;
  }

  Error.fromJson(dynamic json) {
    _message = json['error'] ?? json['message'];
  }

  String? _message;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _message;
    return map;
  }
}
