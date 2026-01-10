class GraphApiRes {
  Chart? chart;

  GraphApiRes({this.chart});

  GraphApiRes.fromJson(Map<String, dynamic> json) {
    chart = json['chart'] != null ? new Chart.fromJson(json['chart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chart != null) {
      data['chart'] = this.chart!.toJson();
    }
    return data;
  }
}

class Chart {
  List<Series>? series;

  Chart({this.series});

  Chart.fromJson(Map<String, dynamic> json) {
    if (json['series'] != null) {
      series = <Series>[];
      json['series'].forEach((v) {
        series!.add(new Series.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.series != null) {
      data['series'] = this.series!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Series {
  String? name;
  List<ChartPoint>? data;

  Series({this.name, this.data});

  Series.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = <ChartPoint>[];
      json['data'].forEach((v) {
        data!.add(new ChartPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChartPoint {
  String? date;
  double? value;

  ChartPoint({this.date, this.value});

  ChartPoint.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    // Handle both int and double values from API
    if (json['value'] != null) {
      if (json['value'] is int) {
        value = (json['value'] as int).toDouble();
      } else if (json['value'] is double) {
        value = json['value'] as double;
      } else {
        value = double.tryParse(json['value'].toString()) ?? 0.0;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['value'] = this.value;
    return data;
  }
}
