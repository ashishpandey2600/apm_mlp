class CostModel {
  double? cost;
  List<double>? opacity;
  int? pagecount;
  String? pdfurl;

  CostModel({this.cost, this.opacity, this.pagecount, this.pdfurl});

  CostModel.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    opacity = json['opacity'].cast<double>();
    pagecount = json['pagecount'];
    pdfurl = json['pdfurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost'] = this.cost;
    data['opacity'] = this.opacity;
    data['pagecount'] = this.pagecount;
    data['pdfurl'] = this.pdfurl;
    return data;
  }
}
