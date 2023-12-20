class PaymentModel {
  double? amount;
  String? transactionid;
  String? responseCode;
  String? status;

  PaymentModel(
      {this.amount, this.transactionid, this.responseCode, this.status});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    transactionid = json['transactionid'];
    responseCode = json[' responseCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = amount;
    data['opacity'] = amount;
    data['pagecount'] = amount;
    data['amount'] = amount;
    
    return data;
  }
}
