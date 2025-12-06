class OrderDetailsApiRes {
  int? code;
  int? taid;
  String? message;
  List<OrderDetailsData>? data;

  OrderDetailsApiRes({this.code, this.taid, this.message, this.data});

  OrderDetailsApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    taid = json['taid'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderDetailsData>[];
      json['data'].forEach((v) {
        data!.add(new OrderDetailsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['taid'] = this.taid;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetailsData {
  int? orderDetailsId;
  int? orderID;
  String? orderNumber;
  int? productID;
  String? productName;
  int? quantity;
  dynamic deliveredQuantity;
  dynamic unitPrice;
  dynamic orderItemAmount;
  dynamic orderTotalAmount;
  int? branchID;
  String? branchName;
  String? orderDate;

  OrderDetailsData({
    this.orderDetailsId,
    this.orderID,
    this.orderNumber,
    this.productID,
    this.productName,
    this.quantity,
    this.deliveredQuantity,
    this.unitPrice,
    this.orderItemAmount,
    this.orderTotalAmount,
    this.branchID,
    this.branchName,
    this.orderDate,
  });

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['orderDetailsId'];
    orderID = json['orderID'];
    orderNumber = json['orderNumber'];
    productID = json['productID'];
    productName = json['productName'];
    quantity = json['quantity'];
    deliveredQuantity = json['deliveredQuantity'];
    unitPrice = json['unitPrice'];
    orderItemAmount = json['orderItemAmount'];
    orderTotalAmount = json['orderTotalAmount'];
    branchID = json['branchID'];
    branchName = json['branchName'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailsId'] = this.orderDetailsId;
    data['orderID'] = this.orderID;
    data['orderNumber'] = this.orderNumber;
    data['productID'] = this.productID;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['deliveredQuantity'] = this.deliveredQuantity;
    data['unitPrice'] = this.unitPrice;
    data['orderItemAmount'] = this.orderItemAmount;
    data['orderTotalAmount'] = this.orderTotalAmount;
    data['branchID'] = this.branchID;
    data['branchName'] = this.branchName;
    data['orderDate'] = this.orderDate;
    return data;
  }
}
