class UploadPdfModel {
  String? docid;
  String? userid;
  String? pdfurl;
  String? pdfid;
  String? transactionid;
  String? pagecount;
  String? price;
  String? opacity;
  DateTime? uploadedon;

  UploadPdfModel(
      {
      this.docid,
      this.userid,
      this.pdfurl,
      this.pdfid,
      this.pagecount,
      this.transactionid,
      this.price,
      this.opacity,
      this.uploadedon});

  UploadPdfModel.fromMap(Map<String, dynamic> map) {
    docid = map['docid'];
    userid = map['userid'];
    pdfurl = map['pdfurl'];
    pdfid = map['pdfid'];
    pagecount = map['pagecount'];
    transactionid = map['transactionid'];
    price = map['price'];
    opacity = map['opacity'];
    uploadedon = map['uploadedon'].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "docid": docid,
      "userid": userid,
      "pdfurl": pdfurl,
      "pdfid": pdfid,
      "pagecount": pagecount,
      "transactionid": transactionid,
      "price": price,
      "opacity": opacity,
      "uploadedon": uploadedon
    };
  }
}
