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
  dynamic gstSlabs;
  double? cgst;
  double? sgst;
  double? pbPrice;
  dynamic basePrice;
  dynamic internalPrice;
  dynamic costPrice;
  dynamic mrp;
  String? weight;
  int? categoryId;
  String? category;
  String? unit;

  ProductList({
    this.productId,
    this.productName,
    this.sku,
    this.hsnCode,
    this.gstSlabs,
    this.cgst,
    this.sgst,
    this.pbPrice,
    this.basePrice,
    this.internalPrice,
    this.costPrice,
    this.mrp,
    this.weight,
    this.categoryId,
    this.category,
    this.unit,
  });

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    sku = json['sku'];
    hsnCode = json['hsnCode'];
    gstSlabs = json['gstSlabs'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    basePrice = json['basePrice'];
    pbPrice = json['pbPrice'];
    internalPrice = json['internalPrice'];
    costPrice = json['costPrice'];
    mrp = json['mrp'];
    weight = json['weight'];
    categoryId = json['categoryId'];
    category = json['category'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['sku'] = this.sku;
    data['hsnCode'] = this.hsnCode;
    data['gstSlabs'] = this.gstSlabs;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['basePrice'] = this.basePrice;
    data['pbPrice'] = this.pbPrice;
    data['internalPrice'] = this.internalPrice;
    data['costPrice'] = this.costPrice;
    data['mrp'] = this.mrp;
    data['weight'] = this.weight;
    data['categoryId'] = this.categoryId;
    data['category'] = this.category;
    data['unit'] = this.unit;
    return data;
  }
}
