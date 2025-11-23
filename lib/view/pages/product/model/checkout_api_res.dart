class CheckOutApiRes {
  int? code;
  String? message;
  int? orderId;
  dynamic totalAmount;

  CheckOutApiRes({this.code, this.message, this.orderId, this.totalAmount});

  CheckOutApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    orderId = json['orderId'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['orderId'] = this.orderId;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
