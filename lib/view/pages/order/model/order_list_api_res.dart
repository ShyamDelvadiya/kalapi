class OrderListApiRes {
  int? code;
  String? message;
  int? totalRecords;
  List<OrderData>? data;

  OrderListApiRes({this.code, this.message, this.totalRecords, this.data});

  OrderListApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    totalRecords = json['totalRecords'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['totalRecords'] = this.totalRecords;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  int? orderID;
  String? orderNumber;
  String? orderDate;
  int? branchID;
  String? branchName;
  int? orderTotalAmount;
  int? remainingAmount;
  int? orderStatusId;
  String? orderStatus;

  OrderData({
    this.orderID,
    this.orderNumber,
    this.orderDate,
    this.branchID,
    this.branchName,
    this.orderTotalAmount,
    this.remainingAmount,
    this.orderStatusId,
    this.orderStatus,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    orderNumber = json['orderNumber'];
    orderDate = json['orderDate'];
    branchID = json['branchID'];
    branchName = json['branchName'];
    orderTotalAmount = json['orderTotalAmount'];
    remainingAmount = json['remainingAmount'];
    orderStatusId = json['orderStatusId'];
    orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderID'] = this.orderID;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] = this.orderDate;
    data['branchID'] = this.branchID;
    data['branchName'] = this.branchName;
    data['orderTotalAmount'] = this.orderTotalAmount;
    data['remainingAmount'] = this.remainingAmount;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatus'] = this.orderStatus;
    return data;
  }
}
