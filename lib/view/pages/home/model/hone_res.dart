class DashboardApiRes {
  int? totalOrders;
  int? totalProduct;

  DashboardApiRes({this.totalOrders, this.totalProduct});

  DashboardApiRes.fromJson(Map<String, dynamic> json) {
    totalOrders = json['TotalOrders'];
    totalProduct = json['TotalProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalOrders'] = this.totalOrders;
    data['TotalProduct'] = this.totalProduct;
    return data;
  }
}
