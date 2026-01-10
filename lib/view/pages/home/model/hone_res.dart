class DashboardApiRes {
  dynamic totalBranches;
  dynamic totalOrders;
  dynamic totalProduct;
  dynamic currentMonthOrderAmount;
  dynamic totalOrderAmount;
  String? totalOrderAmountFormatted;

  DashboardApiRes({
    this.totalBranches,
    this.totalOrders,
    this.totalProduct,
    this.currentMonthOrderAmount,
    this.totalOrderAmount,
    this.totalOrderAmountFormatted,
  });

  DashboardApiRes.fromJson(Map<String, dynamic> json) {
    totalBranches = json['totalBranches'];
    totalOrders = json['totalOrders'];
    totalProduct = json['totalProduct'];
    currentMonthOrderAmount = json['currentMonthOrderAmount'];
    totalOrderAmount = json['totalOrderAmount'];
    totalOrderAmountFormatted = json['totalOrderAmountFormatted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBranches'] = this.totalBranches;
    data['totalOrders'] = this.totalOrders;
    data['totalProduct'] = this.totalProduct;
    data['currentMonthOrderAmount'] = this.currentMonthOrderAmount;
    data['totalOrderAmount'] = this.totalOrderAmount;
    data['totalOrderAmountFormatted'] = this.totalOrderAmountFormatted;
    return data;
  }
}
