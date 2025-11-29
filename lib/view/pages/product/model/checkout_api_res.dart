class CheckOutApiRes {
  int? code;
  String? message;
  int? orderId;
  dynamic totalAmount;
  dynamic discount;

  CheckOutApiRes({
    this.code,
    this.message,
    this.orderId,
    this.totalAmount,
    this.discount,
  });

  CheckOutApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    orderId = json['orderId'];
    totalAmount = json['totalAmount'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['orderId'] = orderId;
    data['totalAmount'] = totalAmount;
    data['discount'] = discount;
    return data;
  }
}
