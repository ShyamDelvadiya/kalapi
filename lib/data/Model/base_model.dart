class BaseResponse {
  BaseResponse({
    dynamic success,
    String? message,
    dynamic data,
    List<Error>? errors,
  }) {
    _success = success;
    _message = message;
    _data = data;
    _error = errors;
  }

  dynamic _success;
  String? _message;
  dynamic _data;
  List<Error>? _error;

  dynamic get success => _success;
  String? get message => _message;
  dynamic get data => _data;
  List<Error>? get error => _error;

  BaseResponse.fromJson(dynamic json) {
    // Defensive parsing: the API sometimes returns a List at the top-level
    // (e.g. [ { ... } ]) instead of a Map. Guard against that case.
    if (json is List) {
      // Treat the list as the data payload
      _success = true;
      _message = null;
      _data = json;
      _error = null;
      return;
    }

    if (json is! Map) return;

    _success = json['success'];
    _message = json['message'];
    _data = json['data'];

    if (json['errors'] != null && json['errors'] is List) {
      _error = [];
      for (var v in json['errors']) {
        _error?.add(Error.fromJson(v));
      }
    } else if (json['error'] != null) {
      if (json['error'] is List) {
        _error = List<Error>.from(
          json['error'].map((e) => Error(message: e.toString())),
        );
      } else if (json['error'] is String) {
        _error = [Error(message: json['error'])];
      } else if (json['error'] is Map) {
        // sometimes error is an object with message key
        _error = [Error.fromJson(json['error'])];
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
    if (json == null) {
      _message = null;
    } else if (json is String) {
      _message = json;
    } else if (json is Map) {
      _message = json['error'] ?? json['message']?.toString();
    } else {
      _message = json.toString();
    }
  }

  String? _message;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _message;
    return map;
  }
}
