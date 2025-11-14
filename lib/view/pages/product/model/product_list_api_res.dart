class ProductApiRes {
  int? code;
  String? message;
  List<ProductList>? data;

  ProductApiRes({this.code, this.message, this.data});

  ProductApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductList>[];
      json['data'].forEach((v) {
        data!.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  int? productId;
  String? productName;
  String? sku;
  String? hsnCode;
  double? cgst;
  double? sgst;
  dynamic basePrice;
  dynamic internalPrice;
  String? weight;

  ProductList({
    this.productId,
    this.productName,
    this.sku,
    this.hsnCode,
    this.cgst,
    this.sgst,
    this.basePrice,
    this.internalPrice,
    this.weight,
  });

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    sku = json['sku'];
    hsnCode = json['hsnCode'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    basePrice = json['basePrice'];
    internalPrice = json['internalPrice'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['sku'] = this.sku;
    data['hsnCode'] = this.hsnCode;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['basePrice'] = this.basePrice;
    data['internalPrice'] = this.internalPrice;
    data['weight'] = this.weight;
    return data;
  }
}
