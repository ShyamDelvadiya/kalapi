class OrderListApiRes {
  int? code;
  String? message;
  List<OrderData>? data;

  OrderListApiRes({this.code, this.message, this.data});

  OrderListApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  int? orderId;
  String? orderNumber;
  int? branchId;
  String? branchName;
  String? customerName;
  String? customerPhone;
  String? orderDate;
  double? totalAmount;
  double? discount;
  double? finalAmount;
  String? status;
  String? paymentStatus;
  String? deliveryAddress;
  String? remarks;
  List<OrderItem>? orderItems;

  OrderData({
    this.orderId,
    this.orderNumber,
    this.branchId,
    this.branchName,
    this.customerName,
    this.customerPhone,
    this.orderDate,
    this.totalAmount,
    this.discount,
    this.finalAmount,
    this.status,
    this.paymentStatus,
    this.deliveryAddress,
    this.remarks,
    this.orderItems,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderNumber = json['orderNumber'];
    branchId = json['branchId'];
    branchName = json['branchName'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    orderDate = json['orderDate'];
    totalAmount = json['totalAmount']?.toDouble();
    discount = json['discount']?.toDouble();
    finalAmount = json['finalAmount']?.toDouble();
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    deliveryAddress = json['deliveryAddress'];
    remarks = json['remarks'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItem>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
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
    data['orderDate'] = orderDate;
    data['totalAmount'] = totalAmount;
    data['discount'] = discount;
    data['finalAmount'] = finalAmount;
    data['status'] = status;
    data['paymentStatus'] = paymentStatus;
    data['deliveryAddress'] = deliveryAddress;
    data['remarks'] = remarks;
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  int? orderItemId;
  int? productId;
  String? productName;
  String? weight;
  int? quantity;
  double? price;
  double? totalPrice;

  OrderItem({
    this.orderItemId,
    this.productId,
    this.productName,
    this.weight,
    this.quantity,
    this.price,
    this.totalPrice,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    productId = json['productId'];
    productName = json['productName'];
    weight = json['weight'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    totalPrice = json['totalPrice']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderItemId'] = orderItemId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['weight'] = weight;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    return data;
  }
}
