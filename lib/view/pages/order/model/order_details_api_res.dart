class OrderDetailsApiRes {
  int? code;
  String? message;
  OrderDetailsData? data;

  OrderDetailsApiRes({this.code, this.message, this.data});

  OrderDetailsApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data =
        json['data'] != null ? OrderDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderDetailsData {
  int? orderId;
  String? orderNumber;
  int? branchId;
  String? branchName;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? orderDate;
  double? totalAmount;
  double? discount;
  double? finalAmount;
  String? status;
  String? paymentStatus;
  String? paymentMethod;
  String? deliveryAddress;
  String? remarks;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  List<OrderDetailsItem>? orderItems;

  OrderDetailsData({
    this.orderId,
    this.orderNumber,
    this.branchId,
    this.branchName,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.orderDate,
    this.totalAmount,
    this.discount,
    this.finalAmount,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.deliveryAddress,
    this.remarks,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.orderItems,
  });

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderNumber = json['orderNumber'];
    branchId = json['branchId'];
    branchName = json['branchName'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    customerEmail = json['customerEmail'];
    orderDate = json['orderDate'];
    totalAmount = json['totalAmount']?.toDouble();
    discount = json['discount']?.toDouble();
    finalAmount = json['finalAmount']?.toDouble();
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    paymentMethod = json['paymentMethod'];
    deliveryAddress = json['deliveryAddress'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    if (json['orderItems'] != null) {
      orderItems = <OrderDetailsItem>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderDetailsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['orderNumber'] = orderNumber;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['customerName'] = customerName;
    data['customerPhone'] = customerPhone;
    data['customerEmail'] = customerEmail;
    data['orderDate'] = orderDate;
    data['totalAmount'] = totalAmount;
    data['discount'] = discount;
    data['finalAmount'] = finalAmount;
    data['status'] = status;
    data['paymentStatus'] = paymentStatus;
    data['paymentMethod'] = paymentMethod;
    data['deliveryAddress'] = deliveryAddress;
    data['remarks'] = remarks;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['modifiedBy'] = modifiedBy;
    data['modifiedDate'] = modifiedDate;
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetailsItem {
  int? orderItemId;
  int? productId;
  String? productName;
  String? productCode;
  String? sku;
  String? weight;
  int? quantity;
  double? price;
  double? totalPrice;
  String? categoryName;

  OrderDetailsItem({
    this.orderItemId,
    this.productId,
    this.productName,
    this.productCode,
    this.sku,
    this.weight,
    this.quantity,
    this.price,
    this.totalPrice,
    this.categoryName,
  });

  OrderDetailsItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    productName = json['productName'];
    productCode = json['productCode'];
    sku = json['sku'];
    weight = json['weight'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    totalPrice = json['totalPrice']?.toDouble();
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderItemId'] = orderItemId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productCode'] = productCode;
    data['sku'] = sku;
    data['weight'] = weight;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['categoryName'] = categoryName;
    return data;
  }
}
