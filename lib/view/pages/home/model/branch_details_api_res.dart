class BranchDetailsApiRes {
  int? branchId;
  String? branchName;
  String? gstNumber;
  String? email;
  String? passWord;
  String? address;
  String? phoneNumber;
  String? emailAppPassword;
  bool? isInternalBranch;
  bool? isPBBranch;
  String? systemInsertedDate;
  String? updatedDate;
  int? userId;

  BranchDetailsApiRes({
    this.branchId,
    this.branchName,
    this.gstNumber,
    this.email,
    this.passWord,
    this.address,
    this.phoneNumber,
    this.emailAppPassword,
    this.isInternalBranch,
    this.isPBBranch,
    this.systemInsertedDate,
    this.updatedDate,
    this.userId,
  });

  BranchDetailsApiRes.fromJson(Map<String, dynamic> json) {
    branchId = json['branchId'];
    branchName = json['branchName'];
    gstNumber = json['gstNumber'];
    email = json['email'];
    passWord = json['passWord'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    emailAppPassword = json['emailAppPassword'];
    isInternalBranch = json['isInternalBranch'];
    isPBBranch = json['isPBBranch'];
    systemInsertedDate = json['systemInsertedDate'];
    updatedDate = json['updatedDate'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchId'] = this.branchId;
    data['branchName'] = this.branchName;
    data['gstNumber'] = this.gstNumber;
    data['email'] = this.email;
    data['passWord'] = this.passWord;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['emailAppPassword'] = this.emailAppPassword;
    data['isInternalBranch'] = this.isInternalBranch;
    data['isPBBranch'] = this.isPBBranch;
    data['systemInsertedDate'] = this.systemInsertedDate;
    data['updatedDate'] = this.updatedDate;
    data['userId'] = this.userId;
    return data;
  }
}
