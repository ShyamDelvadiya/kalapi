class ProductCategoryApiRes {
  int? code;
  String? message;
  List<ProductCategoryList>? data;

  ProductCategoryApiRes({this.code, this.message, this.data});

  ProductCategoryApiRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductCategoryList>[];
      json['data'].forEach((v) {
        data!.add(new ProductCategoryList.fromJson(v));
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

class ProductCategoryList {
  int? categoryId;
  String? category;

  ProductCategoryList({this.categoryId, this.category});

  ProductCategoryList.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['category'] = this.category;
    return data;
  }
}
