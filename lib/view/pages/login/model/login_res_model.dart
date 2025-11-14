class LoginResModel {
  int? code;
  int? taid;
  String? message;
  Data? data;

  LoginResModel({this.code, this.taid, this.message, this.data});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    taid = json['taid'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['taid'] = taid;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userID;
  String? name;
  String? email;
  int? roleID;
  String? phoneNumber;
  bool? isBranch;
  int? branchID;
  bool? isInternalBranch;
  String? tokenExpirationTime;
  String? token;

  Data({
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

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    name = json['name'];
    email = json['email'];
    roleID = json['roleID'];
    phoneNumber = json['phoneNumber'];
    isBranch = json['isBranch'];
    branchID = json['branchID'];
    isInternalBranch = json['isInternalBranch'];
    tokenExpirationTime = json['tokenExpirationTime'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['name'] = name;
    data['email'] = email;
    data['roleID'] = roleID;
    data['phoneNumber'] = phoneNumber;
    data['isBranch'] = isBranch;
    data['branchID'] = branchID;
    data['isInternalBranch'] = isInternalBranch;
    data['tokenExpirationTime'] = tokenExpirationTime;
    data['token'] = token;
    return data;
  }
}
