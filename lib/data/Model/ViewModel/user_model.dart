class UserModel {
  int? userID;
  String? name;
  String? email;
  int? roleID;
  String? phoneNumber;
  bool? isBranch;
  int? branchID;
  bool? isInternalBranch;
  DateTime? tokenExpirationTime;
  String? token;

  UserModel({
    this.userID,
    this.name,
    this.email,
    this.roleID,
    this.phoneNumber,
    this.isBranch,
    this.branchID,
    this.isInternalBranch,
    this.tokenExpirationTime,
    this.token,
  });

  factory UserModel.fromJson(dynamic json) {
    if (json == null) return UserModel();

    DateTime? parsedExpiration;
    final expRaw =
        json['tokenExpirationTime'] ??
        json['token_expiration_time'] ??
        json['expiration'];
    if (expRaw != null) {
      try {
        parsedExpiration = DateTime.tryParse(expRaw.toString());
      } catch (_) {
        parsedExpiration = null;
      }
    }

    return UserModel(
      userID:
          json['userID'] is int
              ? json['userID']
              : (json['userID'] != null
                  ? int.tryParse(json['userID'].toString())
                  : null),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      roleID:
          json['roleID'] is int
              ? json['roleID']
              : (json['roleID'] != null
                  ? int.tryParse(json['roleID'].toString())
                  : null),
      phoneNumber: json['phoneNumber']?.toString(),
      isBranch:
          json['isBranch'] is bool
              ? json['isBranch']
              : (json['isBranch'] != null
                  ? json['isBranch'].toString().toLowerCase() == 'true'
                  : null),
      branchID:
          json['branchID'] is int
              ? json['branchID']
              : (json['branchID'] != null
                  ? int.tryParse(json['branchID'].toString())
                  : null),
      isInternalBranch:
          json['isInternalBranch'] is bool
              ? json['isInternalBranch']
              : (json['isInternalBranch'] != null
                  ? json['isInternalBranch'].toString().toLowerCase() == 'true'
                  : null),
      tokenExpirationTime: parsedExpiration,
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userID'] = userID;
    map['name'] = name;
    map['email'] = email;
    map['roleID'] = roleID;
    map['phoneNumber'] = phoneNumber;
    map['isBranch'] = isBranch;
    map['branchID'] = branchID;
    map['isInternalBranch'] = isInternalBranch;
    map['tokenExpirationTime'] = tokenExpirationTime?.toIso8601String();
    map['token'] = token;
    return map;
  }

  UserModel copyWith({
    int? userID,
    String? name,
    String? email,
    int? roleID,
    String? phoneNumber,
    bool? isBranch,
    int? branchID,
    bool? isInternalBranch,
    DateTime? tokenExpirationTime,
    String? token,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      email: email ?? this.email,
      roleID: roleID ?? this.roleID,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isBranch: isBranch ?? this.isBranch,
      branchID: branchID ?? this.branchID,
      isInternalBranch: isInternalBranch ?? this.isInternalBranch,
      tokenExpirationTime: tokenExpirationTime ?? this.tokenExpirationTime,
      token: token ?? this.token,
    );
  }
}
